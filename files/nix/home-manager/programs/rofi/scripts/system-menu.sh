#!/usr/bin/env bash
set -euo pipefail

declare -A SYSTEM_DICT=(
    ["Reboot"]="reboot"
    ["Sleep"]="suspend"
    ["Poweroff"]="poweroff"
)

IFS=$'\n'
if [[ $# -ne 0 ]]; then
    action="${SYSTEM_DICT[$1]-}"
    if [ -z "$action" ]; then
        exit 0
    fi
    systemctl "$action" &> /dev/null &
    exit 0
else
    echo "${!SYSTEM_DICT[*]}"
fi
