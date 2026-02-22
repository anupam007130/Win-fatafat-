
-- Drop existing function first to change signature (return type)
DROP FUNCTION IF EXISTS public.process_winnings(uuid, text, text, date);

CREATE OR REPLACE FUNCTION public.process_winnings(
    p_game_id uuid, 
    p_winning_number text, 
    p_winning_type text, 
    p_date date
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_won_count integer := 0;
  v_lost_count integer := 0;
  v_total_won_amount decimal := 0;
  bet_record RECORD;
BEGIN
  -- 1. Process winners
  FOR bet_record IN 
    SELECT * FROM bets 
    WHERE game_id = p_game_id 
    AND bet_type = p_winning_type::public.bet_type
    AND bet_number = p_winning_number
    AND status = 'pending'
    AND (created_at AT TIME ZONE 'Asia/Kolkata')::date = p_date
  LOOP
    -- Update bet status
    UPDATE bets 
    SET status = 'won', 
        winning_amount = amount * multiplier 
    WHERE id = bet_record.id;
    
    -- Credit wallet
    UPDATE profiles 
    SET wallet_balance = wallet_balance + (bet_record.amount * bet_record.multiplier)
    WHERE id = bet_record.user_id;

    v_won_count := v_won_count + 1;
    v_total_won_amount := v_total_won_amount + (bet_record.amount * bet_record.multiplier);
  END LOOP;

  -- 2. Mark others as lost for the SAME game, type and date
  WITH updated AS (
    UPDATE bets 
    SET status = 'lost'
    WHERE game_id = p_game_id 
    AND bet_type = p_winning_type::public.bet_type
    AND bet_number != p_winning_number
    AND status = 'pending'
    AND (created_at AT TIME ZONE 'Asia/Kolkata')::date = p_date
    RETURNING id
  )
  SELECT count(*) INTO v_lost_count FROM updated;

  RETURN json_build_object(
    'won_count', v_won_count,
    'lost_count', v_lost_count,
    'total_won_amount', v_total_won_amount
  );
END;
$$;
