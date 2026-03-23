#!/usr/bin/env bash
set -euo pipefail

declare -A SYSTEM_DICT=(
    ["Lock"]="swaylock"
    ["Reboot"]="reboot"
    ["Restart"]="reboot"
    ["Sleep"]="suspend"
    ["Poweroff"]="poweroff"
    ["Shutdown"]="poweroff"
)

IFS=$'\n'

if [[ $# -ne 0 ]]; then
    action="${SYSTEM_DICT[$1]-}"
    [[ -z "$action" ]] && exit 0

    if [[ "$action" == "swaylock" ]]; then
        swaylock &> /dev/null &
    else
        systemctl "$action" &> /dev/null &
    fi
    exit 0
else
    echo "${!SYSTEM_DICT[*]}"
fi
