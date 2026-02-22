-- Ensure is_admin function exists and covers all privileged roles
create or replace function is_admin(uid uuid)
returns boolean language sql security definer as $$
  select exists (
    select 1 from profiles p
    where p.id = uid and p.role in ('admin', 'assistance')
  );
$$;

-- Apply policies to all tables for Admins
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "Admins have full access on %I" ON %I', t, t);
        EXECUTE format('CREATE POLICY "Admins have full access on %I" ON %I FOR ALL TO authenticated USING (is_admin(auth.uid()))', t, t);
    END LOOP;
END $$;

-- Fix WF1003's balance manually based on the approved recharge
update profiles 
set wallet_balance = coalesce(wallet_balance, 0) + 20000 
where user_id_display = 'WF1003';