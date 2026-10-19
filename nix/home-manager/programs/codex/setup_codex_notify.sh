#!/usr/bin/env bash
set -euo pipefail

config_dir="${CODEX_HOME:-${HOME}/.config/codex}"
config_file="${config_dir}/config.toml"

umask 077
mkdir -p "$config_dir"
tmp="$(mktemp "${config_dir}/.config.toml.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

# Read missing configuration as an empty file without modifying it before success.
input_file=/dev/null
if [[ -e "$config_file" ]]; then
  input_file="$config_file"
fi

# Edit only the conventional tables and command lines managed by this script.
# Keep user settings, including an explicit features.hooks = false.
awk '
  function finish_section() {
    if (section == "[features]" && !seen_hooks) print "hooks = true"
    if (section == "[tui]" && !seen_notifications) print "notifications = false"
  }

  function append_hook(event, command) {
    printf "\n[[hooks.%s]]\n[[hooks.%s.hooks]]\n", event, event
    printf "type = \"command\"\ncommand = \"%s\"\ntimeout = 5\n", command
  }

  function matches_command(value, command, literal, suffix) {
    literal = "\"" command "\""
    if (substr(value, 1, length(literal)) != literal) return 0
    suffix = substr(value, length(literal) + 1)
    return suffix ~ /^[[:space:]]*(#.*)?$/
  }

  BEGIN {
    stop = ENVIRON["HOME"] "/.local/bin/notify.sh Codex '\''turn complete'\'' >/dev/null 2>&1 || true"
    permission = ENVIRON["HOME"] "/.local/bin/notify.sh Codex '\''approval required'\'' >/dev/null 2>&1 || true"
    legacy_stop = "~/.local/bin/notify.sh Codex '\''turn complete'\'' >/dev/null 2>&1 || true"
    legacy_permission = "~/.local/bin/notify.sh Codex '\''approval required'\'' >/dev/null 2>&1 || true"
  }

  /^[[:space:]]*\[/ {
    finish_section()
    section = $0
    sub(/[[:space:]]*#.*/, "", section)
    gsub(/[[:space:]]/, "", section)
    if (section == "[features]") seen_features = 1
    if (section == "[tui]") seen_tui = 1
  }

  section == "[features]" && /^[[:space:]]*hooks[[:space:]]*=/ {
    seen_hooks = 1
  }

  section == "[tui]" && /^[[:space:]]*notifications[[:space:]]*=/ {
    seen_notifications = 1
    print "notifications = false"
    next
  }

  /^[[:space:]]*command[[:space:]]*=/ {
    command = legacy = ""
    if (section == "[[hooks.Stop.hooks]]") {
      command = stop
      legacy = legacy_stop
    } else if (section == "[[hooks.PermissionRequest.hooks]]") {
      command = permission
      legacy = legacy_permission
    }
    value = $0
    sub(/^[[:space:]]*command[[:space:]]*=[[:space:]]*/, "", value)
    if (command != "" && matches_command(value, legacy)) {
      start = index($0, "\"")
      $0 = substr($0, 1, start) command substr(value, length(legacy) + 2)
      value = "\"" command "\""
    }
    if (command != "" && matches_command(value, command)) found[section] = 1
  }

  { print }

  END {
    finish_section()
    if (!seen_features) print "\n[features]\nhooks = true"
    if (!seen_tui) print "\n[tui]\nnotifications = false"
    if (!found["[[hooks.Stop.hooks]]"]) append_hook("Stop", stop)
    if (!found["[[hooks.PermissionRequest.hooks]]"]) append_hook("PermissionRequest", permission)
  }
' "$input_file" > "$tmp"

mv -f "$tmp" "$config_file"
