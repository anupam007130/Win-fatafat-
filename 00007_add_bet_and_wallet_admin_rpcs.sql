create or replace function settle_bet(b_id uuid, b_status text, b_winning_amount numeric)
returns void
language plpgsql
security definer
as $$
declare
  v_user_id uuid;
begin
  -- Update bet status and winning amount
  update bets
  set status = b_status, winning_amount = b_winning_amount
  where id = b_id
  returning user_id into v_user_id;

  -- If won, credit wallet
  if b_status = 'won' then
    update profiles
    set wallet_balance = coalesce(wallet_balance, 0) + b_winning_amount
    where id = v_user_id;
  end if;
end;
$$;

create or replace function update_user_wallet(u_id uuid, new_balance numeric)
returns void
language plpgsql
security definer
as $$
begin
  update profiles
  set wallet_balance = new_balance
  where id = u_id;
end;
$$;