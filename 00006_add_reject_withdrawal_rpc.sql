create or replace function reject_withdrawal(w_id uuid)
returns void
language plpgsql
security definer
as $$
declare
  v_amount numeric;
  v_user_id uuid;
  v_status text;
begin
  -- Get withdrawal details
  select amount, user_id, status into v_amount, v_user_id, v_status
  from withdrawals
  where id = w_id;

  if not found then
    raise exception 'Withdrawal not found';
  end if;

  if v_status = 'rejected' then
    return; -- Idempotent
  end if;

  if v_status != 'pending' then
    raise exception 'Can only reject pending withdrawals';
  end if;

  -- Refund to user balance
  update profiles
  set wallet_balance = coalesce(wallet_balance, 0) + v_amount
  where id = v_user_id;

  -- Update withdrawal status
  update withdrawals
  set status = 'rejected'
  where id = w_id;
end;
$$;