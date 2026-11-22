Inspection Pro v92 — Supabase Email + Password Authentication

Database & Sync now uses normal email/password authentication.

Added:
- Create Account
- Sign In
- Sign Out
- Forgot Password
- Connection Status
- Sync Now
- Database connection test retained

Passwords are sent directly to Supabase Authentication and are not stored in Inspection Pro local settings.

Supabase setup note:
For password login, Supabase Authentication -> Providers -> Email must allow Email/Password sign-in.
If Confirm Email is enabled, a new account must confirm its email once before password sign-in works.

All v91 functionality retained.

Inspection Pro v93 draft navigation repair:
- Home no longer overwrites the saved inspection stage.
- Drafts resume at the saved step, including setup.
- App saves on page hide and backgrounding.
- Starting a new inspection warns before replacing the one existing draft.
- This version still supports one active draft, not multiple simultaneous drafts.

Inspection Pro v94 customer sync repair:
- Sync Now uploads locally saved customer records that are absent from Supabase.
- Existing Supabase customers are not overwritten during the initial upload.
- Customers are downloaded again after upload to share across devices.
- The app preserves existing local customer records and drafts.
- This does not yet reconcile conflicting edits or synchronize customer deletions.
