#!/usr/bin/env bash
set -euo pipefail

declare -A BLUETOOTH_DICT=(
    ["bluetooth on"]="power|on|bluetooth on"
    ["bluetooth off"]="power|off|bluetooth off"
)

while read -r line; do
    device_name=$(echo "$line" | cut -d ' ' -f 3-)
    mac_address=$(echo "$line" | cut -d ' ' -f 2)
    if [ -n "$device_name" ] && [ -n "$mac_address" ]; then
        BLUETOOTH_DICT["bluetooth connect $device_name"]="connect|$mac_address|"
    fi
done < <(bluetoothctl devices)

IFS=$'\n'
if [[ $# -ne 0 ]]; then
    action_spec="${BLUETOOTH_DICT[$1]-}"
    if [ -z "$action_spec" ]; then
        exit 0
    fi
    IFS='|' read -r action arg notify <<< "$action_spec"
    case "$action" in
        power)
            bluetoothctl power "$arg" &> /dev/null
            if [ -n "$notify" ]; then
                notify-send -u low "$notify" &> /dev/null
            fi
            ;;
        connect)
            bluetoothctl power on &> /dev/null
            bluetoothctl connect "$arg" &> /dev/null
            ;;
    esac
    exit 0
else
    echo "${!BLUETOOTH_DICT[*]}"
fi
