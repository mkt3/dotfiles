IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)

active_iface=""
for iface in $(sudo wg show interfaces | tr ' ' '\n'); do
  active_iface="$iface"
done

for conf in "${HOME}/.config/wg/"*.conf; do
  addr=$(grep -E '^Address' "$conf" | head -n1 | cut -d= -f2 | cut -d/ -f1)
  if ifconfig "$active_iface" 2>/dev/null | grep -q "$addr"; then
    VPN=$(basename "$conf" .conf)
  fi
done

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

sketchybar --set $NAME \
	icon=$ICON \
	label="$LABEL"
