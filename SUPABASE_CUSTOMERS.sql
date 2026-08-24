-- Inspection Pro v76 - Customer Database
-- Run this in Supabase SQL Editor after the existing v73 setup.

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  customer_id text not null,
  company text not null,
  contact text not null default '',
  phone text not null default '',
  email text not null default '',
  address text not null default '',
  city_state_zip text not null default '',
  usdot text not null default '',
  notes text not null default '',
  updated_at timestamptz not null default now(),
  unique(user_id, customer_id)
);

create index if not exists customers_user_company_idx
  on public.customers(user_id, company);

alter table public.customers enable row level security;

drop policy if exists "Users read own customers" on public.customers;
create policy "Users read own customers"
on public.customers for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "Users insert own customers" on public.customers;
create policy "Users insert own customers"
on public.customers for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "Users update own customers" on public.customers;
create policy "Users update own customers"
on public.customers for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "Users delete own customers" on public.customers;
create policy "Users delete own customers"
on public.customers for delete
to authenticated
using (user_id = auth.uid());

grant select, insert, update, delete on public.customers to authenticated;

-- USDOT numbers are intentionally NOT unique; multiple customer names may share one USDOT number.
