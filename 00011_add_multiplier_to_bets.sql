ALTER TABLE bets ADD COLUMN multiplier numeric DEFAULT 0;
UPDATE bets SET multiplier = 9 WHERE bet_type = 'single';
UPDATE bets SET multiplier = 90 WHERE bet_type = 'juri';
UPDATE bets SET multiplier = 120 WHERE bet_type = 'patti';
