CREATE OR REPLACE FUNCTION process_winnings(
  p_game_id UUID,
  p_winning_number TEXT,
  p_winning_type TEXT,
  p_date DATE
) RETURNS void AS $$
DECLARE
  bet_record RECORD;
BEGIN
  -- 1. Process winners
  FOR bet_record IN 
    SELECT * FROM bets 
    WHERE game_id = p_game_id 
    AND bet_type = p_winning_type::public.bet_type
    AND bet_number = p_winning_number
    AND status = 'pending'
    AND created_at::date = p_date
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
  END LOOP;

  -- 2. Mark others as lost for the SAME game, type and date
  UPDATE bets 
  SET status = 'lost'
  WHERE game_id = p_game_id 
  AND bet_type = p_winning_type::public.bet_type
  AND bet_number != p_winning_number
  AND status = 'pending'
  AND created_at::date = p_date;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
