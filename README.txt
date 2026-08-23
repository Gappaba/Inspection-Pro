Inspection Pro v73 — Database / Sync build

Built from v72 iPhone build.

Added:
- Supabase/PostgreSQL backend support.
- Email magic-link authentication.
- Row-level private data access.
- Push/pull sync of drafts and completed inspections.
- Full inspection snapshots stored in the database.
- Automatic sync attempt when internet connectivity returns.
- Database-generated YEAR-#### inspection numbers when signed in/online.
- Offline local fallback retained.
- Database status and Sync Now controls in Settings.
- SUPABASE_SETUP.sql included.

The app remains usable without a database connection.
A live backend exists only after a Supabase project is created and connected in Settings.
