Inspection Pro v100

Completed-history deletion now syncs. Confirm deletion for a specific
completed inspection. The entry disappears locally and the cloud removal
retries when the app is online and signed in. Other devices see the change
when they run v100 and sync. A small cloud deletion marker prevents a stale
copy from being restored.

For a test inspection that returned after an earlier deletion, delete it
again in v100, then sync. Verify that another completed inspection still
opens, then sync a second device and confirm the test entry stays gone.

This update uses the existing Supabase inspection_records table. No SQL
migration is needed on an already configured installation. See
README_V99.txt for app setup, deployment, and PDF verification.
