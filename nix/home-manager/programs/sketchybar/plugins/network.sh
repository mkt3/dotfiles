#!/usr/bin/env bash

export PATH="@PATH@:/usr/sbin:/usr/bin:/sbin:/bin:${PATH:-}"

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
VPN=""

active_iface=""
WG_BIN="@WG_BIN@"
if [ ! -x "$WG_BIN" ]; then
  WG_BIN=$(command -v wg || true)
fi

if [ -n "$WG_BIN" ]; then
  while read -r iface; do
    active_iface="$iface"
  done < <(sudo -n "$WG_BIN" show interfaces 2>/dev/null | tr ' ' '\n')
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
