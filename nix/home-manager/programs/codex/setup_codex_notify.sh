#!/usr/bin/env bash
set -euo pipefail

config_dir="${CODEX_HOME:-${HOME}/.codex}"
config_file="${config_dir}/config.toml"
stop_command='~/.local/bin/notify.sh Codex '\''turn complete'\'' >/dev/null 2>&1 || true'
permission_command='~/.local/bin/notify.sh Codex '\''approval required'\'' >/dev/null 2>&1 || true'

mkdir -p "$config_dir"
touch "$config_file"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if grep -Eq '^[[:space:]]*\[features\][[:space:]]*$' "$config_file"; then
  if ! awk '
    /^[[:space:]]*\[features\][[:space:]]*$/ { in_features = 1; next }
    /^[[:space:]]*\[/ { in_features = 0 }
    in_features && /^[[:space:]]*hooks[[:space:]]*=/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$config_file"; then
    awk '
      /^[[:space:]]*\[features\][[:space:]]*$/ {
        print
        print "hooks = true"
        next
      }
      { print }
    ' "$config_file" > "$tmp"
    mv "$tmp" "$config_file"
  fi
else
  {
    printf '\n[features]\n'
    printf 'hooks = true\n'
  } >> "$config_file"
fi

if grep -Eq '^[[:space:]]*\[tui\][[:space:]]*$' "$config_file"; then
  awk '
    /^[[:space:]]*\[tui\][[:space:]]*$/ {
      in_tui = 1
      seen_notifications = 0
      print
      next
    }
    /^[[:space:]]*\[/ {
      if (in_tui && !seen_notifications) {
        print "notifications = false"
      }
      in_tui = 0
    }
    in_tui && /^[[:space:]]*notifications[[:space:]]*=/ {
      print "notifications = false"
      seen_notifications = 1
      next
    }
    { print }
    END {
      if (in_tui && !seen_notifications) {
        print "notifications = false"
      }
    }
  ' "$config_file" > "$tmp"
  mv "$tmp" "$config_file"
else
  {
    printf '\n[tui]\n'
    printf 'notifications = false\n'
  } >> "$config_file"
fi

if ! grep -Fq "$stop_command" "$config_file"; then
  {
    printf '\n[[hooks.Stop]]\n'
    printf '[[hooks.Stop.hooks]]\n'
    printf 'type = "command"\n'
    printf 'command = "%s"\n' "$stop_command"
    printf 'timeout = 5\n'
  } >> "$config_file"
fi

if ! grep -Fq "$permission_command" "$config_file"; then
  {
    printf '\n[[hooks.PermissionRequest]]\n'
    printf '[[hooks.PermissionRequest.hooks]]\n'
    printf 'type = "command"\n'
    printf 'command = "%s"\n' "$permission_command"
    printf 'timeout = 5\n'
  } >> "$config_file"
fi
