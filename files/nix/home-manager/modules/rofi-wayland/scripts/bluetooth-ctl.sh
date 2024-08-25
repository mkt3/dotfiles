#!/usr/bin/env bash

declare -A BLUETOOTH_DICT=(
    ["bluetooth on"]="bluetoothctl power on && notify-send -u low \"bluetooth on\""
    ["bluetooth off"]="bluetoothctl power off && notify-send -u low \"bluetooth off\""
)

while read -r LINE; do
    device_name=$(echo "$LINE" | cut -d ' ' -f 3-)
    mac_address=$(echo "$LINE" | cut -d ' ' -f 2)
    BLUETOOTH_DICT["bluetooth connect $device_name"]="bluetoothctl power on && bluetoothctl connect $mac_address"
done < <(bluetoothctl devices)

IFS=$'\n'
if [[ $# -ne 0 ]]; then
    eval "${BLUETOOTH_DICT[$1]}"  &> /dev/null &
    exit 0
else
    echo "${!BLUETOOTH_DICT[*]}"
fi
