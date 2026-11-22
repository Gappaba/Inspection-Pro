Inspection Pro v95 — Automatic Synchronization

Changes from v94:
- Automatically schedules a background Supabase sync after saving customers, vehicles, technicians, or an in-progress inspection.
- Syncs when returning to the app or when the internet connection returns.
- Prevents overlapping sync operations and avoids navigating Home during automatic sync.
- Keeps local saves and the manual Sync Now button.

Requires the existing Supabase connection and signed-in account. An offline save remains local until an online sync succeeds. The current app uses one active draft; cross-device simultaneous editing and conflict resolution are not yet supported. Test on both devices before relying on it for production inspections.

Deploy: extract ZIP and upload index.html and the other package files to the root of the GitHub Pages repository, replacing the existing files. Do not clear browser data or uninstall the Home Screen app.
