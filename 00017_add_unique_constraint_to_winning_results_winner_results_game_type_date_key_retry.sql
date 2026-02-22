
ALTER TABLE public.winning_results
ADD CONSTRAINT winning_results_game_type_date_key UNIQUE (game_id, winning_type, result_date);
