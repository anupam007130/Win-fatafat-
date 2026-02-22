-- One-time fix for users who had recharges approved but balances not updated due to RLS
update profiles p
set wallet_balance = (
  select coalesce(sum(amount), 0) 
  from recharges 
  where user_id = p.id and status = 'approved'
) - (
  select coalesce(sum(amount), 0)
  from bets
  where user_id = p.id
) - (
  select coalesce(sum(amount), 0)
  from withdrawals
  where user_id = p.id and status != 'rejected'
) + (
  select coalesce(sum(winning_amount), 0)
  from bets
  where user_id = p.id and status = 'won'
)
where id in (
  select user_id from recharges where status = 'approved'
);

-- Ensure balance is never negative
update profiles set wallet_balance = 0 where wallet_balance < 0;