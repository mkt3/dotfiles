#!/bin/bash

declare -A WINDOW_LIST

WINDOW_CSV=`swaymsg -t get_tree |
    jq -r '
        # descend to workspace or scratchpad
        .nodes[].nodes[]
        # save workspace name as .w
        | {"w": .name} + (
                if .nodes then # workspace
                        [recurse(.nodes[])]
                else # scratchpad
                        []
                end
                + .floating_nodes
                | .[]
                # select nodes with no children (windows)
                | select(.nodes==[])
        )
        | [
          (.id | tostring),
          (.w | gsub("<[^>]*>|:$"; "") | sub("__i3_scratch"; "[S]")),
           (.app_id // .window_properties.class),
            .name] | @csv' | tail -n +2`

while IFS=, read -r id window name title; do
    KEY=`echo "$window$name$title"| tr -d '" '`
    WINDOW_LIST[$KEY]=`echo $id | tr -d '"'`
    DISPLAY_NAME="${DISPLAY_NAME}$window,$name,$title\n"
done << EOF
$WINDOW_CSV
EOF


IFS=$'\n'
if [[ $# -ne 0 ]]; then
    IDX=`echo $1 | tr -d '" '`
    echo $IDX > ~/a.txt
    swaymsg "[con_id=${WINDOW_LIST[$IDX]}]" focus  &> /dev/null
    exit 0
else
    echo -e "$DISPLAY_NAME" | column -s, -t | tr -d '"'
fi
