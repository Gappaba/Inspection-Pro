Inspection Pro v99
Page 2 recovery verification build

Quick verification
1. Extract the entire ZIP. Open index.html in a desktop browser, or serve the
   extracted directory on localhost. With Python installed, run
   python -m http.server 8000 from that directory and open
   http://localhost:8000/index.html.
2. Confirm the header says v99. Start a sample Minnesota MIP, or reopen an
   unfinished draft in the same browser and at the same hosted address.
3. On the Minnesota MIP Information Form, enter a different tire size on
   each side. On a phone, swipe the axle table horizontally to reach both
   tire-size columns. Clear a previously saved chamber size and continue.
4. Finalize the sample and use VIEW ACTUAL MINNESOTA PDF or SAVE PDF.
   Confirm there are two pages. On page 2 check the inspector name, decal,
   axle measurements, tire sizes, cleared chamber, and the Trailer and
   Safety Devices GVWR boxes. Try Hydraulic Surge, Pressure, and
   Motorcoach N/A in one sample, then Electric, Flow, and PASS in another.
5. Export a sample Federal inspection. Check for one landscape Letter page.

Hosted update and iPhone
Publish the full directory to your static HTTPS host. Keep the same origin
(protocol, hostname, and port) to retain browser-local drafts and history.
Keep browser site data intact. If an installed copy shows the old build,
close all tabs and installed-app windows for the site, then reopen online.
Confirm v99 before using it for a real inspection.

Open the hosted address in Safari and use Share > Add to Home Screen.
For offline verification, open the hosted build online, let it finish
loading, and reload once while online. Then go offline, reopen the app,
and export a local sample. Cloud sync and cloud storage need connectivity.

Supabase for a fresh project
In the SQL Editor, run these scripts in order:
  1. SUPABASE_SETUP.sql
  2. SUPABASE_CUSTOMERS.sql
  3. SUPABASE_VEHICLES.sql
  4. SUPABASE_TECHNICIANS.sql
  5. SUPABASE_REPORT_STORAGE.sql
  6. SUPABASE_REPORT_STORAGE_V96.sql
The app already performs retention cleanup. SUPABASE_RETENTION.sql is
included for installations that explicitly use the legacy retention RPC.

In the app's database settings, enter the project URL and publishable
(or legacy anon) key. Sign in with a test user. Verify draft and history
sync and save a sample completed report to cloud storage. Open its signed
PDF link using OPEN CLOUD PDF. Use the existing schema and settings for
an already working project. Review any database setup changes in a test
project before applying them to an existing deployment.

Verification status
The startup script and PDF generators were exercised in a local JavaScript
harness. Sample exports were rendered with a PDF engine. The Minnesota
export covered all seven axles, the recovered Page 2 selections, blank
tread, separate GVWR fields, and cleared values. Federal output was one
landscape Letter page. Verify layout on your device, offline Home Screen
behavior, and live Supabase sync before using this build in the field.

README.txt and README_V97.txt are retained as release history.
