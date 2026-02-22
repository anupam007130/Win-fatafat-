create or replace function approve_recharge(r_id uuid)
returns void
language plpgsql
security definer
as $$
declare
  v_amount numeric;
  v_user_id uuid;
  v_status text;
begin
  -- Get recharge details
  select amount, user_id, status into v_amount, v_user_id, v_status
  from recharges
  where id = r_id;

  if not found then
    raise exception 'Recharge not found';
  end if;

  if v_status = 'approved' then
    return; -- Already approved, idempotent
  end if;

  if v_status != 'pending' then
    raise exception 'Can only approve pending recharges';
  end if;

  -- Update user balance
  update profiles
  set wallet_balance = coalesce(wallet_balance, 0) + v_amount
  where id = v_user_id;

  -- Update recharge status
  update recharges
  set status = 'approved'
  where id = r_id;
end;
$$;