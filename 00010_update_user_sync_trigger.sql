-- Update the handle_new_user trigger to generate user_id_display
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  user_count int;
  new_id text;
BEGIN
  -- We count profiles to generate the next WFXXXX ID
  SELECT COUNT(*) INTO user_count FROM profiles;
  new_id := 'WF' || (1000 + user_count + 1);
  
  -- Insert a profile synced with fields collected at signup.
  -- NEW.raw_user_meta_data can contain additional info if we use it, 
  -- but we use mobile which is NEW.phone or in meta data
  
  INSERT INTO public.profiles (id, mobile_number, role, user_id_display, wallet_balance, password)
  VALUES (
    NEW.id,
    COALESCE(NEW.phone, (NEW.raw_user_meta_data->>'mobile_number')),
    CASE WHEN user_count = 0 THEN 'admin'::public.user_role ELSE 'user'::public.user_role END,
    new_id,
    0,
    (NEW.raw_user_meta_data->>'password')
  );
  RETURN NEW;
END;
$$;