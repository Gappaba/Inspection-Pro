Inspection Pro v112

Roll out to another inspector

1. On the configured device, sign in and open Database & Sync.
2. Choose Copy Inspector Setup Link and send it to the new inspector.
   The link includes the Supabase project URL and its public browser key.
3. The inspector opens the link on their own device or browser profile,
   chooses Continue to Sign In, and uses their own work email. If the
   project allows account registration, they can choose Create Account.
   Otherwise, the project administrator must invite them in Supabase.
4. The inspector saves their full name and inspector number in Your
   inspector profile. Both inspection forms then use that identity.
5. Verify one test inspection, PDF export and sync with the new account.

For the project administrator
- Use the existing Supabase schema and ensure the technician table is
  installed. No SQL migration is required for this release.
- Configure Supabase Auth with the deployed application's URL and an
  appropriate redirect allowlist. Confirmation and reset links should
  be opened in the browser profile that received the setup link.
- Customer, vehicle, technician and inspection records remain scoped
  to each account. Organization-wide sharing is a separate feature.
- Use a separate OS account or browser profile for each inspector on a
  shared computer. The app binds sync on a browser profile to its first
  signed-in account. Browser profiles should also be physically protected
  if they contain local inspection data.
