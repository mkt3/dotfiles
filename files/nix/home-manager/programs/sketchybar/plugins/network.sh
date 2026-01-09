#!/usr/bin/env bash

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
VPN=""

active_iface=""
if command -v wg > /dev/null 2>&1; then
  while read -r iface; do
    active_iface="$iface"
  done < <(sudo wg show interfaces 2>/dev/null | tr ' ' '\n')
fi

shopt -s nullglob
for conf in "${HOME}/.config/wg/"*.conf; do
  addr=$(grep -E '^Address' "$conf" | head -n1 | cut -d= -f2 | cut -d/ -f1)
  if [ -n "$active_iface" ] && ifconfig "$active_iface" 2>/dev/null | grep -q "$addr"; then
    VPN=$(basename "$conf" .conf)
  fi
done
shopt -u nullglob

if [[ $VPN != "" ]]; then
	ICON=
	LABEL=$VPN
elif [[ $IP_ADDRESS != "" ]]; then
	ICON=
	LABEL=""
else
	ICON=
	LABEL="Not Connected"
fi

sketchybar --set "$NAME" \
	icon="$ICON" \
	label="$LABEL"
