# New Muslim Companion

An offline-first, cross-platform companion app for English-speaking new Muslims
(reverts/converts) with little or no prior knowledge of Islam. It introduces
Islam gradually through journey-based learning, helps with daily worship
(prayer times, Wudu, Salah, duas, Quran, Hadith), answers common beginner
questions through an on-device AI mentor, and helps reverts connect with their
local Muslim community — all without requiring an internet connection after
install.

## Status

This repository currently contains the **Foundation Package**: system
architecture, database schema/ERD, API contract, design system, seed content,
a working Laravel backend, and a working Flutter vertical slice (onboarding →
first lesson → home dashboard with prayer times → on-device AI mentor).

The full product scope (complete content libraries, CMS admin UI, full prayer
module, community directory, notifications, biometric security, app-store
deployment, etc.) is tracked as future work — see
[`docs/architecture/system-architecture.md`](docs/architecture/system-architecture.md)
for what's implemented vs. planned.

## Repository layout

```
docs/            Architecture, ERD, API contract, design system, AI mentor
                 design, testing plan, dev setup guide
content/         Canonical seed content (JSON) + JSON Schemas, shared by
                 backend seeders and the Flutter app's offline database
backend/         Laravel 13 REST API (Sanctum auth, MariaDB/PostgreSQL/SQLite)
app/             Flutter app (Android, iOS, Windows, macOS, Linux, Web/PWA)
scripts/         Dev scripts (e.g. syncing content/ into the Flutter app)
```

## Getting started

See [`docs/setup/dev-setup.md`](docs/setup/dev-setup.md) for full setup
instructions for the backend and the Flutter app.

## Content sources

All Islamic content is drawn from mainstream Sunni sources (Tanzil Quran
text, Saheeh International translation, Ibn Kathir/Al-Sa'di tafsir summaries,
Sahih al-Bukhari, Sahih Muslim, Riyad as-Salihin, An-Nawawi's 40 Hadith).
See [`content/seed/SOURCES.md`](content/seed/SOURCES.md) for full attribution
and licensing notes.
