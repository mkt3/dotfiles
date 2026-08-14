#!/usr/bin/env bash

set -u

export PATH="/etc/profiles/per-user/${USER}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/sketchybar"
# shellcheck source=/dev/null
source "$CONFIG_DIR/colors.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="/tmp/sketchybar-omniwm-${UID}"
STATE_FILE="$STATE_DIR/workspaces.json"
LOCK_DIR="$STATE_DIR/refresh.lock"
LOG_FILE="/tmp/sketchybar_omniwm.log"

mkdir -p "$STATE_DIR" || exit 0
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  lock_pid="$(cat "$LOCK_DIR/pid" 2>/dev/null || true)"
  case "$lock_pid" in
    ''|*[!0-9]*) lock_pid="" ;;
  esac
  if [ -n "$lock_pid" ] && kill -0 "$lock_pid" 2>/dev/null; then
    exit 0
  fi
  rm -f "$LOCK_DIR/pid"
  rmdir "$LOCK_DIR" 2>/dev/null || exit 0
  mkdir "$LOCK_DIR" 2>/dev/null || exit 0
fi
printf '%s\n' "$$" >"$LOCK_DIR/pid"
trap 'rm -f "$LOCK_DIR/pid"; rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT INT TERM

debug() {
  if [ "${OMNIWM_SKETCHYBAR_DEBUG:-0}" = "1" ]; then
    printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG_FILE"
  fi
}

if ! command -v omniwmctl >/dev/null 2>&1 || \
   ! command -v sketchybar >/dev/null 2>&1 || \
   ! command -v jq >/dev/null 2>&1; then
  debug "refresh skipped: omniwmctl, sketchybar, or jq is unavailable"
  exit 0
fi

raw_file="$(mktemp "$STATE_DIR/query.XXXXXX")" || exit 0
next_file="$(mktemp "$STATE_DIR/state.XXXXXX")" || {
  rm -f "$raw_file"
  exit 0
}
trap 'rm -f "$raw_file" "$next_file" "$LOCK_DIR/pid"; rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT INT TERM

if ! omniwmctl query workspace-bar --json >"$raw_file" 2>/dev/null; then
  debug "refresh skipped: OmniWM IPC query failed"
  exit 0
fi

if ! jq -e '
  if .ok == true and .result.kind == "workspace-bar" then
    [
      .result.payload.monitors[]? as $monitor
      | $monitor.workspaces[]?
      | {
          item: ("omniwm.workspace." + (.id | gsub("[^A-Za-z0-9_-]"; "_"))),
          rawName: .rawName,
          displayName: (.displayName // .rawName),
          number: .number,
          isFocused: .isFocused,
          monitorId: $monitor.id
        }
    ]
  else
    error("unexpected OmniWM response")
  end
' "$raw_file" >"$next_file" 2>/dev/null; then
  debug "refresh skipped: unexpected workspace-bar JSON"
  exit 0
fi

old_file="$STATE_FILE"
if [ ! -r "$old_file" ] || ! jq -e 'type == "array"' "$old_file" >/dev/null 2>&1; then
  old_file="/dev/null"
fi

if [ "$old_file" != "/dev/null" ]; then
  while IFS= read -r old_item; do
    if ! jq -e --arg item "$old_item" 'any(.[]; .item == $item)' "$next_file" >/dev/null; then
      sketchybar --remove "$old_item" >>"$LOG_FILE" 2>&1 || true
    fi
  done < <(jq -r '.[].item' "$old_file")
fi

while IFS=$'\t' read -r item number label focused; do
  if [ -z "$item" ]; then
    continue
  fi

  if [ "$old_file" = "/dev/null" ] || \
     ! jq -e --arg item "$item" 'any(.[]; .item == $item)' "$old_file" >/dev/null; then
    sketchybar --add item "$item" left \
               --set "$item" background.color="$NORD_POLAR_NIGHT_LIGHT" \
                             background.corner_radius=5 \
                             background.height=20 \
                             click_script="$SCRIPT_DIR/click.sh" >>"$LOG_FILE" 2>&1 || continue
  fi

  sketchybar --move "$item" before space_separator \
             --set "$item" icon="$number" \
                           label="$label" \
                           background.drawing="$focused" \
                           icon.highlight="$focused" \
                           label.highlight="$focused" >>"$LOG_FILE" 2>&1 || true
done < <(jq -r '
  .[]
  | [.item, (.number | tostring), .displayName, (if .isFocused then "on" else "off" end)]
  | @tsv
' "$next_file")

mv "$next_file" "$STATE_FILE"
next_file=""
rm -f "$raw_file"
raw_file=""
debug "workspace items refreshed"
