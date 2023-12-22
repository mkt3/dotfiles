IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
VPN=$( scutil --nc list | grep Connected | sed -E 's/.*"(.*)".*/\1/')

if [[ $VPN != "" ]]; then
	ICON=
	LABEL=$VPN
elif [[ $IP_ADDRESS != "" ]]; then
	ICON=
	LABEL=$IP_ADDRESS
else
	ICON=
	LABEL="Not Connected"
fi

sketchybar --set $NAME \
	icon=$ICON \
	label="$LABEL"
