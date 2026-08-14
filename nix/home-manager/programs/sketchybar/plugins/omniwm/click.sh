#!/usr/bin/env bash

set -u

export PATH="/etc/profiles/per-user/${USER}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

STATE_DIR="/tmp/sketchybar-omniwm-${UID}"
STATE_FILE="$STATE_DIR/workspaces.json"

if ! command -v omniwmctl >/dev/null 2>&1 || \
   ! command -v jq >/dev/null 2>&1 || \
   [ ! -r "$STATE_FILE" ] || [ -z "${NAME:-}" ]; then
  exit 0
fi

workspace="$(jq -r --arg item "$NAME" '.[] | select(.item == $item) | .rawName' "$STATE_FILE" 2>/dev/null | head -n 1)"
[ -n "$workspace" ] || exit 0

# focus-name accepts a raw workspace ID or an unambiguous configured name.
omniwmctl workspace focus-name "$workspace" >/dev/null 2>&1 || true
