create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  user_count int;
  new_user_id text;
begin
  select count(*) into user_count from public.profiles;
  
  -- Generate User ID (e.g., WF1001)
  new_user_id := 'WF' || (1000 + user_count + 1)::text;

  insert into public.profiles (id, user_id_display, mobile_number, password, role)
  values (
    new.id,
    new_user_id,
    new.raw_user_meta_data->>'mobile_number',
    new.raw_user_meta_data->>'password',
    case when user_count = 0 then 'admin'::public.user_role else 'user'::public.user_role end
  );
  return new;
end;
$$;
