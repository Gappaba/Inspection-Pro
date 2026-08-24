insert into storage.buckets (id,name,public) values ('inspection-reports','inspection-reports',false) on conflict (id) do nothing;

drop policy if exists "Users read own report files" on storage.objects;
create policy "Users read own report files" on storage.objects for select to authenticated
using (bucket_id='inspection-reports' and (storage.foldername(name))[1]=auth.uid()::text);

drop policy if exists "Users upload own report files" on storage.objects;
create policy "Users upload own report files" on storage.objects for insert to authenticated
with check (bucket_id='inspection-reports' and (storage.foldername(name))[1]=auth.uid()::text);
