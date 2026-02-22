CREATE OR REPLACE FUNCTION set_bet_multiplier()
RETURNS TRIGGER AS $$
DECLARE
  v_multiplier NUMERIC;
BEGIN
  -- Fetch the current multiplier from bet_settings for the specific game and type
  SELECT multiplier INTO v_multiplier
  FROM public.bet_settings
  WHERE game_id = NEW.game_id AND bet_type = NEW.bet_type;

  -- If found, set it on the bet record. This ensures the multiplier is locked 
  -- at the time of placing the bet and cannot be tampered with by the client.
  IF v_multiplier IS NOT NULL THEN
    NEW.multiplier := v_multiplier;
  ELSE
    -- If settings are missing, we should probably fail the bet to be safe
    RAISE EXCEPTION 'Bet settings not found for game_id % and bet_type %', NEW.game_id, NEW.bet_type;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_bet_multiplier ON public.bets;
CREATE TRIGGER trigger_set_bet_multiplier
BEFORE INSERT ON public.bets
FOR EACH ROW
EXECUTE FUNCTION set_bet_multiplier();
