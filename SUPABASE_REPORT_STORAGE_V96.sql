-- Run once in Supabase SQL Editor. Keeps the bucket private and existing objects intact.
INSERT INTO storage.buckets (id,name,public)
VALUES ('inspection-reports','inspection-reports',false)
ON CONFLICT (id) DO UPDATE SET public=false;

DROP POLICY IF EXISTS "Users update own report files" ON storage.objects;
CREATE POLICY "Users update own report files"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id='inspection-reports' AND (storage.foldername(name))[1]=auth.uid()::text)
WITH CHECK (bucket_id='inspection-reports' AND (storage.foldername(name))[1]=auth.uid()::text);
