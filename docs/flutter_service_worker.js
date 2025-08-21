'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "dae5ed81a3f6db340cf92df4a9d314ca",
"version.json": "5c0ae5c9eab5075da9eb4ceb29d31c30",
"index.html": "34c8e503145799712ec9e96d1690adba",
"/": "34c8e503145799712ec9e96d1690adba",
"main.dart.js": "dc6c1f5c65ae0a2e1b5f8569ce6750eb",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "a534c6448434ac74c5945b6dceeac24b",
"assets/AssetManifest.json": "52096ee2216e2ec590dfc89f907197bc",
"assets/NOTICES": "c2d43e32437337f7034c9b579a1ef777",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "08022f925c9680c37c1a3683a7714dd0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "aced8d65259dcb663f789071e85163cc",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/assets/images/pieces/black_king.png": "cf85a1046537efdeed31f67dc2fefc2c",
"assets/assets/images/pieces/white_prom_lance.png": "ec14011ceb7482412a362772f2278bb5",
"assets/assets/images/pieces/black_knight.png": "d6d969c0e7341f45015a8cb7b041e9cd",
"assets/assets/images/pieces/white_knight.png": "27981a0d72f1314826ebb72917819d6b",
"assets/assets/images/pieces/black_prom_pawn.png": "30b3f3f5d4cf783b5bf94996370004a4",
"assets/assets/images/pieces/white_prom_knight.png": "85fb97787094a77fb750ec8139fe9ccc",
"assets/assets/images/pieces/white_dragon.png": "e832695aa2dd5edd3bbcb2efa87ec297",
"assets/assets/images/pieces/black_prom_silver.png": "5d411565408428f9c7302ea0576d27b5",
"assets/assets/images/pieces/black_dragon.png": "efdd0d87104baec220c9f02b83596497",
"assets/assets/images/pieces/white_pawn.png": "40903c6158a4829a3d81292a08bed8e8",
"assets/assets/images/pieces/white_prom_pawn.png": "e38b5e01c5947418a5459b1f08c83bd1",
"assets/assets/images/pieces/white_gold.png": "b8e5180edc01ddc51d52f397da4d1623",
"assets/assets/images/pieces/black_rook.png": "86953b751ad70a8d579438929b314848",
"assets/assets/images/pieces/white_king.png": "6108302d9392768afa0f6f6b39535661",
"assets/assets/images/pieces/black_king2.png": "91c642dd541f43132a1997da1c41d7d9",
"assets/assets/images/pieces/white_king2.png": "b3e566003fac27d25bae6b4c9cdf7514",
"assets/assets/images/pieces/black_pawn.png": "da3f3bc96fd39935230c7e1530cca694",
"assets/assets/images/pieces/white_lance.png": "54c9d02c9ac321306458915c23ca9205",
"assets/assets/images/pieces/white_prom_silver.png": "089cb2d3f2129e675e6162f3bea9417c",
"assets/assets/images/pieces/black_prom_lance.png": "5e5a17f0fb46af3cc4405df1fe984800",
"assets/assets/images/pieces/black_horse.png": "9e36b43bf40fc6fa1388c16a02bcdb6b",
"assets/assets/images/pieces/black_prom_knight.png": "bbb42a1bbdc127975fb61d8b7dce4e10",
"assets/assets/images/pieces/piece.png": "be018d3947b0d81e37387b2303354d70",
"assets/assets/images/pieces/white_horse.png": "0f8a8f8082425136fa8ed569847a4ad2",
"assets/assets/images/pieces/black_lance.png": "c039ec7c61d1dffa21444fba69e2b724",
"assets/assets/images/pieces/hitomoji_wood.zip": "01fb5af0c43d45d2ab40e32efa70958f",
"assets/assets/images/pieces/white_rook.png": "d4d9f252eec294a66baea08484893a66",
"assets/assets/images/pieces/white_bishop.png": "205bf55c9571737c00e333aa8432bb4b",
"assets/assets/images/pieces/white_silver.png": "c2930d6eedee9b918d43338f7e9af6c2",
"assets/assets/images/pieces/black_gold.png": "ff16a890948126d42fd6240a9d6c269b",
"assets/assets/images/pieces/black_bishop.png": "e5e800ce3f58933799e2952812671cb5",
"assets/assets/images/pieces/black_silver.png": "e22282b91680c13d1c484a7d47b1c504",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
