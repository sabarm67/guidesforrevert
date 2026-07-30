# Content Sync & Versioning — Future Work

> **Status: not implemented in the Foundation Package.** This document
> records the intended design so the schema decisions made now (the
> `content_versions` table, the `GET /api/v1/content/manifest` stub route)
> don't have to be revisited when this is built. Nothing below exists as
> working code yet.

## Problem

The app ships a bundled content snapshot (`content/seed/*.json`) inside the
app package. Over time, scholars/admins will publish new or corrected lessons,
duas, hadith explanations, etc. through the future CMS. Devices that already
installed the app need a way to pull down just the content that changed,
without a full app-store update and without re-downloading the entire content
library on a slow or metered connection.

## Intended design (not yet built)

1. Every content table gains a `version` and `updated_at` — `lessons` and
   `ai_faq_entries` already have `version`/`updated_at` in the current
   schema; the remaining content tables would need the same before this
   ships.
2. `content_versions` (already in the schema) records, per content type, the
   currently-published version and a checksum of its full serialized
   payload.
3. `GET /api/v1/content/manifest` (already stubbed as `x-status: planned` in
   the OpenAPI spec) returns the current `{content_type, version, checksum}`
   for every content type.
4. The client stores the manifest version it last imported (in
   `ContentVersionMeta`, already present in the Drift schema for this
   reason). On each app foreground (when online), it fetches the manifest
   and diffs it against its local versions.
5. For any content type whose version differs, the client calls a
   type-specific delta endpoint (e.g. `GET /api/v1/lessons?since_version=N`)
   and merges the changes into Drift.
6. Conflict resolution: since content is scholar/admin-authored and
   read-only from the device's perspective, there is no merge conflict to
   resolve for content sync — the server's version always wins. This is
   simpler than the user-generated-data sync problem below.

## Separate problem: user progress/journal sync (also future work)

Account-based sync of `lesson_progress`, `quiz_attempts`, and
`journal_entries` is a different, harder problem (multi-device conflict
resolution, e.g. a lesson marked complete offline on two devices before
either synced). This is intentionally **not designed in detail here** — it
is out of scope for the Foundation Package and should get its own design
pass (likely last-write-wins per row with `updated_at`, given the low
stakes of the data, but this needs real scrutiny before being built).
