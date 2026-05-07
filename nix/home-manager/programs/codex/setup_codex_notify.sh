#!/usr/bin/env bash
set -euo pipefail

config_dir="${CODEX_HOME:-${HOME}/.codex}"
config_file="${config_dir}/config.toml"
notify_line='notify = ["sh", "-lc", "~/.local/bin/notify.sh Codex '\''turn complete'\'' >/dev/null 2>&1 || true"]'
permission_command='~/.local/bin/notify.sh Codex '\''approval required'\'' >/dev/null 2>&1 || true'

mkdir -p "$config_dir"
touch "$config_file"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if ! grep -Eq '^[[:space:]]*notify[[:space:]]*=' "$config_file"; then
  awk -v notify_line="$notify_line" '
    !inserted && $0 ~ /^[[:space:]]*\[/ {
      print notify_line
      print ""
      inserted = 1
    }
    { print }
    END {
      if (!inserted) {
        print notify_line
      }
    }
  ' "$config_file" > "$tmp"
  mv "$tmp" "$config_file"
fi

if grep -Eq '^[[:space:]]*\[features\][[:space:]]*$' "$config_file"; then
  if ! awk '
    /^[[:space:]]*\[features\][[:space:]]*$/ { in_features = 1; next }
    /^[[:space:]]*\[/ { in_features = 0 }
    in_features && /^[[:space:]]*codex_hooks[[:space:]]*=/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$config_file"; then
    awk '
      /^[[:space:]]*\[features\][[:space:]]*$/ {
        print
        print "codex_hooks = true"
        next
      }
      { print }
    ' "$config_file" > "$tmp"
    mv "$tmp" "$config_file"
  fi
else
  {
    printf '\n[features]\n'
    printf 'codex_hooks = true\n'
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
