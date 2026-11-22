Inspection Pro v96 — Report Cloud Storage (test build)

New:
- After finalization, attempts to upload completed inspection PDF and discrepancy photos to private Supabase Storage.
- Final screen includes SAVE TO CLOUD (retry) and OPEN CLOUD PDF (signed URL).
- Corrects Minnesota completed PDF export to use the existing native Minnesota form generator.
- Keeps locally saved completed inspection and current v95 synchronization features.

Setup: Supabase private inspection-reports bucket and existing read/insert policies are required.
Run SUPABASE_REPORT_STORAGE_V96.sql in Supabase SQL Editor to allow updating an existing uploaded report. It does not delete existing records.

Limitations: Cloud upload is best-effort; if offline or upload fails, use SAVE TO CLOUD again when connected. Automatic retry of all historical completed reports is not yet implemented. Test with a sample inspection before using in production. Report downloads from other devices can be accessed after syncing inspection history and opening that completed inspection.

V96 TEST RELEASE (built from v95 reference):
- Original v95 home logo restored as home-logo.png. Upload this file alongside index.html.
- Federal PDF output uses one-page US Letter landscape.
- Cloud PDF and photo upload requires Supabase inspection-reports bucket and correct policies.
- Verify completed Federal PDF, logo, customer/vehicle/technician sync, and cloud upload before production use.
- Do not clear local browser/app storage during update.
