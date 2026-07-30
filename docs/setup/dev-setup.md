# Development Setup

Verified on this machine: Windows 11, PHP 8.3.31, Composer 2.10.2, Git
2.54.0 already installed. Flutter SDK is **not** installed yet — installing
it is a prerequisite step below.

## Backend (Laravel)

Prerequisites already satisfied on this machine (PHP 8.2+ required by
Laravel 13; 8.3.31 is installed).

```bash
cd backend
composer install
copy .env.example .env
php artisan key:generate
php artisan install:api
php artisan migrate --seed
php artisan test
php artisan serve
```

- Local dev uses SQLite (`DB_CONNECTION=sqlite`) so no separate database
  server is required to start developing. Production targets MariaDB or
  PostgreSQL — since Eloquent's query builder is DB-agnostic, switching is
  just an `.env` change (`DB_CONNECTION=mysql` or `pgsql` plus connection
  details), as long as no MySQL/Postgres-specific column types were used in
  migrations (none are, in this schema).
- Verify manually: `curl http://127.0.0.1:8000/api/v1/duas/daily` should
  return a JSON dua payload.

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
# from the repo root, populate app/assets/content/ from content/seed/
./scripts/sync-content.sh    # or scripts/sync-content.ps1 on Windows

cd app
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
`app/web/`, matching the versions of the installed `sqlite3`/`drift`
packages. These are not generated automatically by `flutter create` — see
the Drift web platform documentation for the exact copy command to run
after `flutter pub get`, and re-run it whenever the `drift`/`sqlite3`
package versions are bumped.

## Repository-wide content sync

`content/seed/**/*.json` is the single canonical source of Islamic content
for this phase. The backend seeders read it directly from the sibling
`content/` folder (no copy needed). The Flutter app cannot reliably declare
assets living outside its own project folder across all target platforms'
build tooling, so `scripts/sync-content.ps1`/`.sh` copies the JSON into
`app/assets/content/` — re-run this script any time `content/seed/` changes
and before running/building the Flutter app.
