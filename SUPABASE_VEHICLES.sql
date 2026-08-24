create table if not exists public.customer_vehicles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vehicle_id text not null,
  customer_id text not null,
  unit text not null default '',
  vehicle_type text not null default 'Truck',
  vin text not null default '',
  year text not null default '',
  make text not null default '',
  model text not null default '',
  plate text not null default '',
  plate_state text not null default '',
  odometer_type text not null default 'Chassis',
  axles integer not null default 2,
  notes text not null default '',
  updated_at timestamptz not null default now(),
  unique(user_id, vehicle_id)
);
create index if not exists customer_vehicles_user_customer_idx on public.customer_vehicles(user_id, customer_id);
create index if not exists customer_vehicles_user_vin_idx on public.customer_vehicles(user_id, vin);
alter table public.customer_vehicles enable row level security;
drop policy if exists "Users read own vehicles" on public.customer_vehicles;
create policy "Users read own vehicles" on public.customer_vehicles for select to authenticated using (user_id = auth.uid());
drop policy if exists "Users insert own vehicles" on public.customer_vehicles;
create policy "Users insert own vehicles" on public.customer_vehicles for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "Users update own vehicles" on public.customer_vehicles;
create policy "Users update own vehicles" on public.customer_vehicles for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "Users delete own vehicles" on public.customer_vehicles;
create policy "Users delete own vehicles" on public.customer_vehicles for delete to authenticated using (user_id = auth.uid());
grant select, insert, update, delete on public.customer_vehicles to authenticated;
