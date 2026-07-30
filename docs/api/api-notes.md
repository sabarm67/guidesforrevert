# API Notes

## Conventions

- **Base path**: `/api/v1`.
- **Auth**: Laravel Sanctum personal access tokens (`Authorization: Bearer <token>`),
  not cookie/session auth. Chosen because the client fleet spans mobile,
  desktop and web, and a single bearer-token flow behaves identically on all
  of them — no CSRF/cookie-domain complications for native/desktop clients.
- **Success envelope**: every endpoint returns `{ "data": ... }`, and paginated
  list endpoints additionally return a `meta` object (`current_page`,
  `per_page`, `total`), matching Laravel's default `JsonResource`/
  `AnonymousResourceCollection` behaviour.
- **Errors**: validation failures return HTTP 422 with Laravel's standard
  shape: `{ "message": "...", "errors": { "field": ["..."] } }`. Not-found
  returns a plain 404 with `{ "message": "..." }`. Authorization failures
  return 401 (missing/invalid token) or 403 (authenticated but not permitted).
- **Versioning**: the URL prefix (`/v1`) is the versioning strategy; breaking
  changes get a new prefix rather than breaking existing clients silently.

## `x-status` extension

Every path in `openapi.yaml` is tagged `x-status: implemented` or
`x-status: planned`. This is not a standard OpenAPI keyword — it's a
project convention so the same document serves as both the API reference
and an honest backlog of what's actually been built vs. designed-but-not-built
in the Foundation Package. Do not assume a `planned` path works.

## Why "today's dua" needs no server-side state

`GET /duas/daily` picks from the set of `duas` where `is_daily_featured = true`
using `dayOfYear % count`. This is deterministic and stateless: the same
calendar day always produces the same dua for every user, with no need to
persist "which dua was shown today" anywhere. The Flutter client mirrors this
exact calculation offline (see `frontend/lib/features/home/`) so the two never
disagree, whether or not the device is online.
