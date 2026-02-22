-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Enum for User Roles
create type public.user_role as enum ('user', 'admin', 'assistance');

-- Enum for Game Status
create type public.game_status as enum ('active', 'inactive', 'coming_soon');

-- Enum for Bet Types
create type public.bet_type as enum ('single', 'juri', 'patti');

-- Enum for Bet Status
create type public.bet_status as enum ('pending', 'won', 'lost');

-- Enum for Transaction Status
create type public.transaction_status as enum ('pending', 'approved', 'rejected');

-- Profiles Table
create table public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  user_id_display text unique not null, -- Auto-generated User ID (e.g., WF1001)
  mobile_number text unique not null,
  wallet_balance decimal(12, 2) default 0.00 not null,
  role public.user_role default 'user'::public.user_role not null,
  is_frozen boolean default false not null,
  created_at timestamptz default now() not null
);

-- Games Table
create table public.games (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  start_time time not null,
  end_time time not null,
  status public.game_status default 'active' not null,
  result_link text,
  created_at timestamptz default now() not null
);

-- Bet Settings Table (Rules for each game/type)
create table public.bet_settings (
  id uuid default uuid_generate_v4() primary key,
  game_id uuid references public.games(id) on delete cascade not null,
  bet_type public.bet_type not null,
  min_bet decimal(10, 2) default 10.00 not null,
  multiplier decimal(10, 2) default 9.00 not null, -- e.g. 9x for single
  unique(game_id, bet_type)
);

-- Bets Table
create table public.bets (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  game_id uuid references public.games(id) on delete cascade not null,
  bet_type public.bet_type not null,
  bet_number text not null, -- '0'-'9', '10'-'99', '100'-'999'
  amount decimal(10, 2) not null,
  status public.bet_status default 'pending' not null,
  winning_amount decimal(10, 2) default 0.00,
  created_at timestamptz default now() not null
);

-- Winning Results Table
create table public.winning_results (
  id uuid default uuid_generate_v4() primary key,
  game_id uuid references public.games(id) on delete cascade not null,
  winning_number text not null, -- The single digit result mostly, but strictly it determines all
  result_date date default current_date not null,
  created_at timestamptz default now() not null
);

-- Recharges Table
create table public.recharges (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  amount decimal(10, 2) not null,
  utr text not null,
  screenshot_url text, -- Optional
  status public.transaction_status default 'pending' not null,
  created_at timestamptz default now() not null
);

-- Withdrawals Table
create table public.withdrawals (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  amount decimal(10, 2) not null,
  method text not null, -- 'upi' or 'bank'
  details jsonb not null, -- Stores UPI ID or Bank Details
  status public.transaction_status default 'pending' not null,
  created_at timestamptz default now() not null
);

-- System Settings Table
create table public.system_settings (
  key text primary key,
  value text not null
);

-- Assistance Permissions Table
create table public.assistance_permissions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  module text not null, -- e.g., 'users', 'games', 'recharge', 'withdrawal'
  can_access boolean default false not null,
  unique(user_id, module)
);

-- Insert Default Settings
insert into public.system_settings (key, value) values
('min_recharge', '300'),
('min_withdrawal', '500'),
('whatsapp_support', '919876543210'),
('qr_code_url', '');

-- Storage Bucket for Images (QR, Screenshots)
insert into storage.buckets (id, name, public) values ('win_fatafat_images', 'win_fatafat_images', true);

-- Policies --

-- Profiles
alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone" on public.profiles for select using (true);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- Games (Public Read, Admin Write)
alter table public.games enable row level security;
create policy "Games are viewable by everyone" on public.games for select using (true);
create policy "Admins can manage games" on public.games for all using (
  exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
);

-- Bet Settings (Public Read, Admin Write)
alter table public.bet_settings enable row level security;
create policy "Bet settings are viewable by everyone" on public.bet_settings for select using (true);
create policy "Admins can manage bet settings" on public.bet_settings for all using (
  exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
);

-- Bets (User View Own, Admin View All, User Insert)
alter table public.bets enable row level security;
create policy "Users can view own bets" on public.bets for select using (auth.uid() = user_id);
create policy "Admins can view all bets" on public.bets for select using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'assistance'))
);
create policy "Users can place bets" on public.bets for insert with check (auth.uid() = user_id);

-- Recharges (User View Own, Admin View All, User Insert)
alter table public.recharges enable row level security;
create policy "Users can view own recharges" on public.recharges for select using (auth.uid() = user_id);
create policy "Admins can view all recharges" on public.recharges for select using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'assistance'))
);
create policy "Admins can update recharges" on public.recharges for update using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'assistance'))
);
create policy "Users can request recharge" on public.recharges for insert with check (auth.uid() = user_id);

-- Withdrawals (User View Own, Admin View All, User Insert)
alter table public.withdrawals enable row level security;
create policy "Users can view own withdrawals" on public.withdrawals for select using (auth.uid() = user_id);
create policy "Admins can view all withdrawals" on public.withdrawals for select using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'assistance'))
);
create policy "Admins can update withdrawals" on public.withdrawals for update using (
  exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'assistance'))
);
create policy "Users can request withdrawal" on public.withdrawals for insert with check (auth.uid() = user_id);

-- System Settings (Public Read, Admin Write)
alter table public.system_settings enable row level security;
create policy "Settings viewable by everyone" on public.system_settings for select using (true);
create policy "Admins can manage settings" on public.system_settings for all using (
  exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
);

-- Storage Policies
create policy "Public Access" on storage.objects for select using ( bucket_id = 'win_fatafat_images' );
create policy "Authenticated Upload" on storage.objects for insert with check ( bucket_id = 'win_fatafat_images' and auth.role() = 'authenticated' );

-- Functions --

-- Function to handle new user signup
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

  insert into public.profiles (id, user_id_display, mobile_number, role)
  values (
    new.id,
    new_user_id,
    new.raw_user_meta_data->>'mobile_number',
    case when user_count = 0 then 'admin'::public.user_role else 'user'::public.user_role end
  );
  return new;
end;
$$;

-- Trigger for new user
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
