# Testing Plan — Foundation Package

## Backend (Laravel / Pest)

| Layer | What's tested | Location |
|---|---|---|
| Feature tests | One per implemented endpoint: register, login, logout, me, learning-stages index, lessons-by-stage, lesson detail, today's-dua | `backend/tests/Feature/` |
| Determinism test | `duas/daily` returns the same dua for two calls on the same date, and can differ across two different dates (test by freezing/travelling time, e.g. `Carbon::setTestNow`) | `backend/tests/Feature/DuaDailyTest.php` |
| Unit tests | Any non-trivial logic extracted out of controllers (e.g. the daily-dua rotation calculation, in its own small service class so it's testable without an HTTP round-trip) | `backend/tests/Unit/` |

Run everything: `php artisan test` (aliased as `composer test`), using
standard PHPUnit — Laravel 13's own default test setup. **Note:** the plan
originally called for Pest, but `pestphp/pest-plugin-laravel` does not yet
declare support for Laravel 13 on PHP 8.3 (its latest release requires PHP
8.4, which isn't installed on this machine) — re-evaluate Pest once either
constraint changes. All tests use Laravel's `RefreshDatabase` trait against
the SQLite test database, with either the real seeders or lightweight model
factories for fixtures.

## Flutter

| Layer | What's tested | Location |
|---|---|---|
| Unit tests | `ai_mentor_matcher.dart` scoring logic — the most important thing to get right and the cheapest to test thoroughly, since it's pure Dart with no widget dependency | `app/test/features/ai_mentor/` |
| Unit tests | `SeedImporter` — imports once, does not duplicate rows on a second run (idempotency) | `app/test/core/db/` |
| Widget tests | Onboarding screen (answering the background question persists it); lesson-detail screen's "Mark Complete" flow | `app/test/features/onboarding/`, `app/test/features/learning/` |
| End-to-end vertical slice | launch app → answer onboarding → open Stage 1 Lesson 1 → mark complete → verify Home dashboard reflects it as the current stage/continue point → verify a prayer-times card renders a non-null time for a fixed test location | `app/test/vertical_slice_test.dart` |

Run everything: `flutter test`.

**Note on `integration_test`:** the plan originally called for a true
on-device/browser `integration_test` run. That wasn't possible on this dev
machine — Windows desktop needs the Visual Studio C++ workload (not
installed) and this Flutter version's `integration_test` package doesn't
support `flutter test -d chrome` (it needs `flutter drive` + chromedriver,
a separate setup this phase didn't configure). The vertical-slice test
above exercises the exact same real widget tree and providers via plain
`flutter_test` instead, which covers the same behaviour end-to-end. Revisit
a true `integration_test`/`flutter drive` run once either toolchain is
available — iOS remains out of reach regardless (requires a Mac).

## Manual verification (not automated this phase)

- Run the full vertical slice with the device's network disabled, to
  directly confirm the offline-first requirement holds for onboarding →
  lesson → home dashboard → prayer times → AI mentor.
- Type a phrasing close to a seeded `question_variant` into the AI Mentor and
  confirm it returns the matched answer with an expandable, working "Sources"
  link. Type something unrelated to any seed entry and confirm the graceful
  fallback + scholar-consultation message appears (never a blank screen or a
  fabricated-sounding answer).
- Confirm `docs/architecture/system-architecture.md` and `er-diagram.md`
  mermaid diagrams render correctly (VS Code Mermaid preview or GitHub), and
  that `docs/api/openapi.yaml` is valid (any OpenAPI linter/validator).

## Explicitly out of scope this phase

CI pipeline configuration, cross-platform build matrix automation (e.g. GitHub
Actions building all 6 targets), load/performance testing, accessibility
audit tooling, and security penetration testing — these belong to later
phases (deployment guide, security documentation) once there's a full
feature set to test against.
