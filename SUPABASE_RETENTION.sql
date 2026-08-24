-- Inspection Pro v80 - MIP / Federal DOT retention policy
-- ONLY completed Minnesota MIP and Federal DOT / U.S. Federal Periodic inspections
-- are subject to the 14 months + 5 days automatic deletion rule.

create or replace function public.purge_expired_inspections()
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  deleted_count integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  delete from public.inspection_records
  where user_id = auth.uid()
    and status = 'completed'
    and inspection_type in (
      'Minnesota MIP',
      'U.S. Federal Periodic Inspection',
      'US Federal Periodic Inspection',
      'Federal DOT Inspection'
    )
    and completed_at < (now() - interval '14 months 5 days');

  get diagnostics deleted_count = row_count;
  return deleted_count;
end;
$$;

revoke all on function public.purge_expired_inspections() from public;
grant execute on function public.purge_expired_inspections() to authenticated;
