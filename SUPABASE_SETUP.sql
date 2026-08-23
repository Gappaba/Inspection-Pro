-- Inspection Pro v73 - Supabase database setup
-- Run this once in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.inspection_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  local_id text not null,
  inspection_number text,
  status text not null check (status in ('draft','completed')),
  inspection_type text not null default '',
  completed_at timestamptz,
  customer text not null default '',
  unit text not null default '',
  vin text not null default '',
  plate text not null default '',
  overall_result text check (overall_result is null or overall_result in ('PASS','FAIL')),
  snapshot jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  unique(user_id, local_id),
  unique(user_id, inspection_number)
);

create index if not exists inspection_records_user_updated_idx
  on public.inspection_records(user_id, updated_at desc);

create index if not exists inspection_records_user_vin_idx
  on public.inspection_records(user_id, vin);

create table if not exists public.inspection_counters (
  user_id uuid not null references auth.users(id) on delete cascade,
  year integer not null,
  last_number integer not null default 0,
  primary key(user_id, year)
);

alter table public.inspection_records enable row level security;
alter table public.inspection_counters enable row level security;

drop policy if exists "Users read own inspections" on public.inspection_records;
create policy "Users read own inspections"
on public.inspection_records for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "Users insert own inspections" on public.inspection_records;
create policy "Users insert own inspections"
on public.inspection_records for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "Users update own inspections" on public.inspection_records;
create policy "Users update own inspections"
on public.inspection_records for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "Users delete own inspections" on public.inspection_records;
create policy "Users delete own inspections"
on public.inspection_records for delete
to authenticated
using (user_id = auth.uid());

create or replace function public.next_inspection_number(p_year integer)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  next_no integer;
begin
  if uid is null then
    raise exception 'Authentication required';
  end if;

  insert into public.inspection_counters(user_id, year, last_number)
  values(uid, p_year, 1)
  on conflict(user_id, year)
  do update set last_number = public.inspection_counters.last_number + 1
  returning last_number into next_no;

  return p_year::text || '-' || lpad(next_no::text, 4, '0');
end;
$$;

revoke all on function public.next_inspection_number(integer) from public;
grant execute on function public.next_inspection_number(integer) to authenticated;

grant select, insert, update, delete on public.inspection_records to authenticated;
