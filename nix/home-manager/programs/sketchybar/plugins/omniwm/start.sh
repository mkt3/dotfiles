#!/usr/bin/env bash

set -u

export PATH="/etc/profiles/per-user/${USER}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="/tmp/sketchybar-omniwm-${UID}"
PID_FILE="$STATE_DIR/watch.pid"
LOG_FILE="/tmp/sketchybar_omniwm.log"

mkdir -p "$STATE_DIR" || exit 0

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG_FILE"
}

if [ -r "$PID_FILE" ]; then
  old_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  case "$old_pid" in
    ''|*[!0-9]*) old_pid="" ;;
  esac

  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null || true
    attempts=0
    while kill -0 "$old_pid" 2>/dev/null && [ "$attempts" -lt 40 ]; do
      sleep 0.05
      attempts=$((attempts + 1))
    done
    if kill -0 "$old_pid" 2>/dev/null; then
      log "existing watcher $old_pid did not stop; refusing to start a duplicate"
      exit 0
    fi
  fi
  rm -f "$PID_FILE"
fi

if ! command -v omniwmctl >/dev/null 2>&1 || ! command -v sketchybar >/dev/null 2>&1; then
  log "omniwmctl or sketchybar is not available on PATH"
  exit 0
fi

nohup "$SCRIPT_DIR/watch.sh" >>"$LOG_FILE" 2>&1 </dev/null &
watch_pid=$!
printf '%s\n' "$watch_pid" >"$PID_FILE"
log "started workspace-bar watcher (pid $watch_pid)"
