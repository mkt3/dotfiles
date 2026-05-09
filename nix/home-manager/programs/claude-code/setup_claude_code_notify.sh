#!/usr/bin/env bash
set -euo pipefail

settings_dir="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"
settings_file="${settings_dir}/settings.json"
stop_command="~/.local/bin/notify.sh 'Claude Code' 'turn complete' >/dev/null 2>&1 || true"
permission_command="~/.local/bin/notify.sh 'Claude Code' 'approval required' >/dev/null 2>&1 || true"

mkdir -p "$settings_dir"
if [ ! -s "$settings_file" ]; then
  printf '{}\n' > "$settings_file"
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

jq \
  --arg stop_command "$stop_command" \
  --arg permission_command "$permission_command" \
  '
    def command_hook($command): {
      "type": "command",
      "command": $command,
      "timeout": 5
    };

    def hook_group($command): {
      "hooks": [command_hook($command)]
    };

    .hooks.Stop = ((.hooks.Stop // []) + [hook_group($stop_command)] | unique)
    | .hooks.PermissionRequest = ((.hooks.PermissionRequest // []) + [hook_group($permission_command)] | unique)
    | .env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
  ' "$settings_file" > "$tmp"

mv "$tmp" "$settings_file"
