#!/usr/bin/env bash
set -e

# Paste this into the Forge site's Zero-Downtime Deployment "Deployment
# Script" field. Forge does NOT create or activate releases for you around
# the script — the CREATE_RELEASE, ACTIVATE_RELEASE, and RESTART_QUEUES
# macros below must be called explicitly, in this order, or the new
# release is built but `current` never gets repointed at it (see
# https://forge.laravel.com/docs/sites/deployments).
#
# IMPORTANT: Forge substitutes these three macros via a literal, unscoped
# text search-and-replace across the WHOLE script — including inside
# comments. Never write out a macro's exact "$NAME()" form anywhere except
# its real call site below, or Forge will splice generated bash into the
# middle of a comment line and corrupt everything after it.
#
# Laravel lives at the repo root (composer.json, artisan, public/ etc. are
# all here directly), so Forge's Web Directory can stay at the default
# `/public` — no custom path config needed. The Flutter app lives in
# frontend/ and is NOT built by this script (it isn't served by this site
# in this phase); building/deploying the Flutter Web/PWA target is future
# work, see docs/setup/dev-setup.md.

$CREATE_RELEASE()

cd "$FORGE_RELEASE_DIRECTORY"

$FORGE_COMPOSER install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Forge's own "Linking storage directories" step (which runs before this
# script) points storage/ at a shared, persistent directory outside the
# release so logs/cache survive across deploys. On a freshly provisioned
# site that shared directory starts empty — it doesn't have the
# framework/{cache,sessions,testing,views} subdirectories a plain git
# checkout gets for free via .gitignore placeholders. Recreate them
# defensively so `artisan optimize` (specifically view:cache) doesn't fail
# with "View path not found" on a brand-new site.
mkdir -p storage/framework/cache/data storage/framework/sessions \
         storage/framework/testing storage/framework/views \
         storage/app/public storage/logs

$FORGE_PHP artisan optimize
$FORGE_PHP artisan storage:link
$FORGE_PHP artisan migrate --force

# Filament's CSS/JS assets (public/css/filament, public/js/filament) are
# vendor-derived build artifacts and are gitignored rather than committed —
# regenerate them fresh on every deploy instead.
$FORGE_PHP artisan filament:assets

# Everything above runs against the new release before it's live. Only
# after this point does `current` get repointed at it:
$ACTIVATE_RELEASE()

# PHP-FPM workers cache their resolution of the `current` symlink (via
# PHP's realpath_cache) for the lifetime of the worker process — activating
# a release repoints the symlink, but already-running workers keep serving
# whichever release they resolved it to at their last cache refresh. In
# practice this meant a `php artisan db:seed` run via SSH (a fresh process,
# resolves the symlink fresh) was immediately visible to `artisan tinker`
# but NOT to live web requests until this reload ran. Reload (not restart)
# so in-flight requests finish against the old code first.
( flock -w 10 9 || exit 1
    echo 'Reloading PHP-FPM...'; sudo -S service "$FORGE_PHP_FPM" reload ) 9>/tmp/fpmlock

# Queue workers/Horizon keep running on the old code until restarted —
# do this after activation so they pick up the new release.
$RESTART_QUEUES()
