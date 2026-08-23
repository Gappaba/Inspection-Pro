Inspection Pro v69 — iPhone/PWA build

Built from v68.

iPhone changes:
- Apple Home Screen / standalone web-app metadata.
- PWA manifest and app icons.
- Responsive mobile-first layout.
- iPhone safe-area support for notch / Dynamic Island / Home indicator.
- 48px+ touch targets.
- 16px form controls to prevent Safari auto-zoom.
- Responsive signature canvas.
- Fixed bottom mobile navigation.
- Service worker for app-shell offline caching after first HTTPS load.
- Settings includes iPhone installation instructions.

Important:
- For full iPhone behavior, host this folder at an HTTPS web address.
- Open the HTTPS address in Safari and choose Share > Add to Home Screen.
- GPS and service-worker/offline features are not reliable when index.html is opened directly from the iPhone Files app.
- The existing PDF-lib library is still loaded from its CDN; Minnesota completed-PDF generation therefore needs connectivity unless that library has already been cached by the browser.

Inspection behavior:
- Federal remains based on v66F/v68 progression.
- Minnesota remains based on locked v53 behavior.
- v68 annual YEAR-SEQUENCE inspection numbering retained.
- v67 History / Reports functionality retained.
