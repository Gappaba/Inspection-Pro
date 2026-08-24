-- Inspection Pro v84 - Simplified Technician / Inspector Profiles

create table if not exists public.technicians (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  technician_id text not null,
  name text not null,
  email text not null default '',
  phone text not null default '',
  employee_no text not null default '',
  inspector_no text not null default '',
  notes text not null default '',
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  unique(user_id, technician_id)
);

-- If v83 was already run, the extra columns may remain in the database.
-- The v84 app does not display, collect, or use them.

create index if not exists technicians_user_name_idx on public.technicians(user_id, name);
alter table public.technicians enable row level security;

drop policy if exists "Users read own technicians" on public.technicians;
create policy "Users read own technicians" on public.technicians for select to authenticated using (user_id = auth.uid());

drop policy if exists "Users insert own technicians" on public.technicians;
create policy "Users insert own technicians" on public.technicians for insert to authenticated with check (user_id = auth.uid());

drop policy if exists "Users update own technicians" on public.technicians;
create policy "Users update own technicians" on public.technicians for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "Users delete own technicians" on public.technicians;
create policy "Users delete own technicians" on public.technicians for delete to authenticated using (user_id = auth.uid());

grant select, insert, update, delete on public.technicians to authenticated;
