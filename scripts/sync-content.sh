#!/usr/bin/env bash
# Copies canonical content JSON from content/seed/ into frontend/assets/content/
# so it can be declared as a Flutter asset and bundled into every platform
# build. Re-run this whenever content/seed/ changes.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
src="$repo_root/content/seed"
dest="$repo_root/frontend/assets/content"

mkdir -p "$dest"
rm -rf "${dest:?}"/*
cp -r "$src"/. "$dest"/

echo "Synced content/seed/ -> frontend/assets/content/"
