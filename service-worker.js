const cachePrefix = "inspection-pro-precache-";
const cacheName = cachePrefix + "v119";
const entry = new URL("index.html", self.registration.scope).href;
const root = self.registration.scope;
const files = new Set([
  entry,
  ...[
    "manifest.webmanifest", "vendor/pdf-lib.min.js",
    "icons/icon-180.png", "icons/icon-192.png", "icons/icon-512.png"
  ].map(path => new URL(path, root).href)
]);

self.addEventListener("install", event => {
  event.waitUntil(caches.open(cacheName).then(cache =>
    cache.addAll([...files].map(url => new Request(url, { cache: "reload" })))
  ));
});

self.addEventListener("activate", event => {
  event.waitUntil((async () => {
    const names = await caches.keys();
    await Promise.all(names.filter(name => name.startsWith(cachePrefix) && name !== cacheName)
      .map(name => caches.delete(name)));
    await self.clients.claim();
  })());
});

self.addEventListener("fetch", event => {
  if (event.request.method !== "GET") return;
  const url = new URL(event.request.url);
  url.search = "";
  const isAppNavigation = event.request.mode === "navigate" && (url.href === root || url.href === entry);
  if (!isAppNavigation && !files.has(url.href)) return;

  event.respondWith((async () => {
    const cache = await caches.open(cacheName);
    if (isAppNavigation) {
      try {
        return await fetch(event.request);
      } catch (error) {
        const offline = await cache.match(entry);
        if (offline) return offline;
        throw error;
      }
    }
    return (await cache.match(url.href)) || fetch(event.request);
  })());
});
