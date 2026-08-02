# Development Setup

Verified on this machine: Windows 11, PHP 8.3.31, Composer 2.10.2, Git
2.54.0 already installed. Flutter SDK is **not** installed yet — installing
it is a prerequisite step below.

## Backend (Laravel)

Laravel lives at the **repo root** (composer.json, artisan, app/, public/
etc. are all here directly) — not in a subfolder — so that deployment
tools like Laravel Forge that run `composer install` at the release root
work without any custom path configuration. The Flutter app lives
alongside it in `frontend/`.

Prerequisites already satisfied on this machine (PHP 8.2+ required by
Laravel 13; 8.3.31 is installed).

```bash
composer install
copy .env.example .env
php artisan key:generate
php artisan install:api
php artisan filament:assets
php artisan migrate --seed
php artisan test
php artisan serve
```

`filament:assets` publishes the CMS panel's CSS/JS into `public/css/filament`
and `public/js/filament` — these are gitignored (vendor-derived build
output), so run this once after `composer install` and again after
upgrading Filament.

- Local dev uses SQLite (`DB_CONNECTION=sqlite`) so no separate database
  server is required to start developing. Production targets MariaDB or
  PostgreSQL — since Eloquent's query builder is DB-agnostic, switching is
  just an `.env` change (`DB_CONNECTION=mysql` or `pgsql` plus connection
  details), as long as no MySQL/Postgres-specific column types were used in
  migrations (none are, in this schema).
- Verify manually: `curl http://127.0.0.1:8000/api/v1/duas/daily` should
  return a JSON dua payload.

## CMS admin portal (Filament, `/admin`)

The CMS is a separate, session-authenticated Filament panel (not part of
the Sanctum API). It has no seeded login by design — create your own admin
user, then grant it one of the three panel-access roles (`admin`,
`scholar_reviewer`, `content_editor` — `RoleSeeder`, part of `migrate --seed`
above, creates the roles themselves):

```bash
php artisan make:filament-user
php artisan tinker --execute="App\Models\User::where('email', 'YOUR_EMAIL')->first()->assignRole('admin');"
```

Then visit `/admin` and log in. Covers CRUD for learning stages, lessons
(with a structured content-block builder, including image uploads), duas
(with audio upload), Quran surahs/ayahs (with nested translations/tafsirs),
hadith collections/hadiths, and AI mentor FAQ entries — see
[`../architecture/system-architecture.md`](../architecture/system-architecture.md)
for what's covered vs. future work.

## Flutter app

### 1. Install the Flutter SDK (one-time, not yet done on this machine)

1. Download the Flutter SDK for Windows from the official Flutter site and
   extract it (e.g. to `C:\src\flutter`).
2. Add `C:\src\flutter\bin` to your `PATH`.
3. Run `flutter doctor` and resolve anything it flags (Android Studio +
   Android SDK for Android builds; Visual Studio with the "Desktop
   development with C++" workload for Windows desktop builds).
4. Enable desktop targets: `flutter config --enable-windows-desktop`
   (macOS/Linux desktop support is enabled automatically on those OSes when
   using the corresponding toolchain — not applicable when developing from
   Windows).

**iOS builds require a Mac** (Xcode is macOS-only) and cannot be built or
tested from this Windows machine. This does not block Android, Windows,
Linux, macOS (from a Mac), or Web/PWA development — treat iOS as a separate
future step needing access to Mac hardware or a cloud Mac CI runner.

### 2. Sync content and install dependencies

```bash
# from the repo root, populate frontend/assets/content/ from content/seed/
./scripts/sync-content.sh    # or scripts/sync-content.ps1 on Windows

cd frontend
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates Drift code
flutter analyze
flutter test
```

### 3. Run the app

```bash
flutter run -d windows   # or: -d chrome, -d <android-device-id>
```

On first launch, `SeedImporter` imports the bundled `assets/content/*.json`
files into the local Drift database — this only happens once, gated by the
`ContentVersionMeta` table. To re-trigger it during development, uninstall
the app (or clear its local storage) to reset that flag.

### Flutter Web-specific note

Drift's web backend needs `sqlite3.wasm` and `drift_worker.js` present under
`frontend/web/`, matching the versions of the installed `sqlite3`/`drift`
packages (see https://drift.simonbinder.eu/web/ for background). These are
not generated automatically by `flutter create` and are deliberately
`.gitignore`d rather than committed, so fetch them after `flutter pub get`:

1. Check the exact locked versions:
   `grep -A2 "name: drift$" frontend/pubspec.lock` and
   `grep -A2 "name: sqlite3$" frontend/pubspec.lock`.
2. Download the matching release assets (adjust the version tags below to
   match step 1):
   ```bash
   curl -sL -o frontend/web/drift_worker.js \
     https://github.com/simolus3/drift/releases/download/drift-2.31.0/drift_worker.js
   curl -sL -o frontend/web/sqlite3.wasm \
     https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.9.4/sqlite3.wasm
   ```

Re-run this whenever the `drift`/`sqlite3` package versions are bumped —
`flutter build web`/`flutter run -d chrome` will fail at runtime with
"When compiling to the web, the `web` parameter needs to be set" style
errors (or a blank screen) if these files are missing or mismatched.

### Flutter Web preview caching gotcha

Flutter's web bootstrap loads `main.dart.js` via a fixed, non-versioned URL
(no content-hash query string), so serving `frontend/build/web/` with a
plain static file server (e.g. `python -m http.server`) lets the browser
silently keep using a stale build after a rebuild — no error, the app just
keeps running old code, which can look exactly like a real bug (this cost
real debugging time once already). `scripts/dev-web-server.py` (used by the
`flutter-web-preview` launch config) sends `Cache-Control: no-store` on
every response to prevent this — always serve `build/web/` through it (or
an equivalent no-cache server) rather than a bare `http.server`, and when
in doubt after a rebuild, do a genuine hard reload
(`window.location.reload(true)` from devtools, not just a normal navigate)
before concluding a change didn't take effect.

## Repository-wide content sync

`content/seed/**/*.json` is the single canonical source of Islamic content
for this phase. The backend seeders read it directly from the sibling
`content/` folder (no copy needed). The Flutter app cannot reliably declare
assets living outside its own project folder across all target platforms'
build tooling, so `scripts/sync-content.ps1`/`.sh` copies the JSON into
`frontend/assets/content/` — re-run this script any time `content/seed/`
changes and before running/building the Flutter app.

## Production deployment (Laravel Forge)

Because Laravel lives at the repo root, Forge's default Zero-Downtime
Deployment flow works with **no custom Web Directory setting** — it stays
at the default `/public`. See [`../../scripts/forge-deploy.sh`](../../scripts/forge-deploy.sh)
for the deploy script to paste into the Forge site's "Deployment Script"
field (based on the same working pattern used by the sibling Hafazan
project).

### Flutter Web/PWA (served at the site root)

The Flutter Web build is committed **pre-built** directly into `public/`
(alongside Laravel's own `index.php`, `.htaccess`, etc. — no filename
collisions) and served at `https://guides.rcaquacycle.com/` — the
production server has no Flutter SDK installed, so it can't run
`flutter build web` itself the way it runs `composer install`. The
`GET /` Laravel route (`routes/web.php`) explicitly serves
`public_path('index.html')` as a safety net, since whether nginx's `index`
directive serves the static file directly or falls through to `index.php`
first isn't something verifiable without server access — this way both
paths work. The old root JSON health-check moved to `GET /status`.

Whenever a frontend change should reach the web build, rebuild and re-copy
locally, then commit and push like any other change:

```bash
cd frontend
flutter build web --release --base-href /
cd ..
rm -rf public/app  # old subpath deploy location, no longer used
git rm -r --cached public/app 2>/dev/null  # only needed once, if still tracked
cp -r frontend/build/web/. public/
rm -rf public/canvaskit   # ~37MB local fallback the bootstrap doesn't
                          # use by default (it fetches CanvasKit from
                          # Google's CDN, gstatic.com/flutter-canvaskit,
                          # unless useLocalCanvasKit is set) — dropping
                          # it keeps the repo lean with no behaviour change.
git add public/
git commit -m "Update deployed web build"
git push
```

Forge's normal git-based Zero-Downtime Deployment then ships the new
`public/` contents on the next deploy — no changes to `forge-deploy.sh`
needed, since these are just files checked out with the rest of the
release.
