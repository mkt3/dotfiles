#!/usr/bin/env bash

declare -A SYSTEM_DICT=(
    ["Reboot"]="systemctl reboot"
    ["Sleep"]="systemctl suspend"
    ["Poweroff"]="systemctl poweroff"
)

IFS=$'\n'
if [[ $# -ne 0 ]]; then
    eval "${SYSTEM_DICT[$1]}" &> /dev/null &
    exit 0
else
    echo "${!SYSTEM_DICT[*]}"
fi
