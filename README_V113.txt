Inspection Pro v113

Shared customers and vehicles

A Supabase directory team shares one customer and vehicle list across its
inspector accounts. Inspector profiles, draft and completed inspections,
and report storage still belong to their respective accounts.

Administrator setup

1. Confirm the original accounts have synced their current customers and
   vehicles. The import in step 4 reads the existing Supabase records.
2. In Supabase SQL Editor, run SUPABASE_SHARED_DIRECTORY_V113.sql after
   the existing customer and vehicle setup scripts.
3. In SQL Editor, create a team. Run this once and copy the returned ID.

   insert into public.inspection_directory_teams (name)
   values ('Company directory') returning id;

   Add each existing Supabase login that should share the directory.
   Replace the UUID and example email addresses with your actual values.

   insert into public.inspection_directory_members (team_id, user_id)
   select 'YOUR-TEAM-UUID'::uuid, id
   from auth.users
   where lower(email) in ('owner@example.com', 'inspector@example.com')
   on conflict (user_id) do nothing
   returning user_id;

   Check that every intended account was added. A setup link alone does
   not grant membership. An account can belong to one directory team.
4. With permission from your organization, import the authoritative
   existing directory. Run it first for the primary account. Repeat for
   other authorized source accounts only when their records belong in
   the same directory.

   select public.seed_inspection_directory('YOUR-TEAM-UUID'::uuid, id)
   from auth.users where lower(email) = 'owner@example.com';

   The import copies records and retains their original IDs and private
   copies. It skips a team record if its ID already exists. It does
   not merge independently created duplicate customers, or import a
   vehicle without its parent customer. Review any records that existed
   only on one device, and add those to the shared directory if needed.
   This import is for initial setup. Re-running it can bring back an
   intentionally deleted record from the old private copy.
5. Publish v113 and have each team member run Database & Sync > Sync Now.
   Verify that both accounts see the same customer and vehicle. Test
   creation, edits and deletion with sample records.

Shared directory edits need a connection. Once synced, the last
downloaded list can be used offline. Move or remove a customer's
vehicles before deleting the customer. Older app versions continue
using their own private lists, so update every inspector before making
shared edits.
