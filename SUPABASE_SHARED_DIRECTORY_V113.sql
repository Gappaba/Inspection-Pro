-- Run after SUPABASE_CUSTOMERS.sql and SUPABASE_VEHICLES.sql.
begin;

create table if not exists public.inspection_directory_teams (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) > 0)
);

-- Each Supabase account can use one shared directory in this app.
create table if not exists public.inspection_directory_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  team_id uuid not null references public.inspection_directory_teams(id) on delete cascade
);
create index if not exists inspection_dir_members_team_idx
  on public.inspection_directory_members(team_id);

create table if not exists public.inspection_team_customers (
  like public.customers including defaults
);
alter table public.inspection_team_customers drop column if exists user_id;
alter table public.inspection_team_customers drop column if exists id;
alter table public.inspection_team_customers add column if not exists team_id uuid not null
 references public.inspection_directory_teams(id) on delete cascade;
create unique index if not exists inspection_team_customers_key
 on public.inspection_team_customers(team_id, customer_id);

create table if not exists public.inspection_team_vehicles (
  like public.customer_vehicles including defaults
);
alter table public.inspection_team_vehicles drop column if exists user_id;
alter table public.inspection_team_vehicles drop column if exists id;
alter table public.inspection_team_vehicles add column if not exists team_id uuid not null;
create unique index if not exists inspection_team_vehicles_key
 on public.inspection_team_vehicles(team_id, vehicle_id);
create index if not exists inspection_team_vehicles_customer_idx
 on public.inspection_team_vehicles(team_id, customer_id);
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'inspection_team_vehicle_customer'
      and conrelid = 'public.inspection_team_vehicles'::regclass
  ) then
    alter table public.inspection_team_vehicles add constraint inspection_team_vehicle_customer
      foreign key(team_id, customer_id) references public.inspection_team_customers(team_id, customer_id)
      on delete restrict;
  end if;
end
$$;

alter table public.inspection_directory_teams enable row level security;
alter table public.inspection_directory_members enable row level security;
alter table public.inspection_team_customers enable row level security;
alter table public.inspection_team_vehicles enable row level security;

revoke all on public.inspection_directory_teams, public.inspection_directory_members,
 public.inspection_team_customers, public.inspection_team_vehicles from public, anon, authenticated;
grant select on public.inspection_directory_members to authenticated;
grant select, insert, update, delete on public.inspection_team_customers, public.inspection_team_vehicles to authenticated;

drop policy if exists "Read own directory membership" on public.inspection_directory_members;
create policy "Read own directory membership" on public.inspection_directory_members
 for select to authenticated using (user_id = (select auth.uid()));

drop policy if exists "Team members manage customers" on public.inspection_team_customers;
create policy "Team members manage customers" on public.inspection_team_customers
 for all to authenticated
 using (team_id in (select m.team_id from public.inspection_directory_members m where m.user_id = (select auth.uid())))
 with check (team_id in (select m.team_id from public.inspection_directory_members m where m.user_id = (select auth.uid())));

drop policy if exists "Team members manage vehicles" on public.inspection_team_vehicles;
create policy "Team members manage vehicles" on public.inspection_team_vehicles
 for all to authenticated
 using (team_id in (select m.team_id from public.inspection_directory_members m where m.user_id = (select auth.uid())))
 with check (team_id in (select m.team_id from public.inspection_directory_members m where m.user_id = (select auth.uid())));

-- Admin-only, explicit import. Existing per-user rows are retained.
create or replace function public.seed_inspection_directory(target_team uuid, source_user uuid)
returns void language plpgsql set search_path = '' as $$
begin
  if not exists (
    select 1 from public.inspection_directory_members m
    where m.team_id = target_team and m.user_id = source_user
  ) then
    raise exception 'Add the source account to this team before importing.';
  end if;

  insert into public.inspection_team_customers
    (team_id, customer_id, company, contact, phone, email, address, city_state_zip, usdot, notes, updated_at)
  select target_team, customer_id, company, contact, phone, email, address, city_state_zip, usdot, notes, updated_at
    from public.customers where user_id = source_user
  on conflict (team_id, customer_id) do nothing;

  insert into public.inspection_team_vehicles
    (team_id, vehicle_id, customer_id, unit, vehicle_type, vin, year, make, model, plate, plate_state, odometer_type, axles, notes, updated_at)
  select target_team, v.vehicle_id, v.customer_id, v.unit, v.vehicle_type, v.vin, v.year, v.make, v.model, v.plate, v.plate_state, v.odometer_type, v.axles, v.notes, v.updated_at
    from public.customer_vehicles v
    join public.inspection_team_customers c on c.team_id = target_team and c.customer_id = v.customer_id
    where v.user_id = source_user
  on conflict (team_id, vehicle_id) do nothing;
end
$$;
revoke all on function public.seed_inspection_directory(uuid, uuid) from public, anon, authenticated;
commit;
