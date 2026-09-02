#!/usr/bin/env bash

set -u

export PATH="/etc/profiles/per-user/${USER}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

STATE_DIR="/tmp/sketchybar-omniwm-${UID}"
PID_FILE="$STATE_DIR/watch.pid"
child_pid=""

cleanup() {
  if [ -n "$child_pid" ]; then
    kill "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
  fi
  if [ -r "$PID_FILE" ] && [ "$(cat "$PID_FILE" 2>/dev/null)" = "$$" ]; then
    rm -f "$PID_FILE"
  fi
}
terminate() {
  cleanup
  trap - EXIT
  exit 0
}
trap cleanup EXIT
trap terminate INT TERM

failure_logged=0
while true; do
  if omniwmctl ping >/dev/null 2>&1; then
    omniwmctl watch workspace-bar --reconnect \
      --exec sketchybar --trigger omniwm_refresh OMNIWM_EVENT_CHANNEL=workspace-bar &
    child_pid=$!
    wait "$child_pid"
    status=$?
    child_pid=""
    if [ "$status" -ne 0 ] && [ "$failure_logged" -eq 0 ]; then
      printf '%s omniwmctl watch exited with status %s; retrying\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" "$status"
      failure_logged=1
    fi
    sleep 2
  else
    if [ "$failure_logged" -eq 0 ]; then
      printf '%s OmniWM IPC is unavailable; waiting for recovery\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')"
      failure_logged=1
    fi
    # This is only a reconnect check; workspace state is never polled.
    sleep 5
  fi
done
