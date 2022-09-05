#!/bin/bash
BOOKMARK_DATA=`cat ~/Nextcloud/bookmark/filemark.txt`

declare -A BOOKMARK_DICT

IFS=" | "
while read line
do
    BOOKMARK=(${line})

    KEY="${BOOKMARK[1]}(${BOOKMARK[0]})"
    BOOKMARK_DICT[$KEY]=${BOOKMARK[0]}
done <<FILE
$BOOKMARK_DATA
FILE

IFS=$'\n'
if [[ $# -ne 0 ]]; then
   xdg-open "${BOOKMARK_DICT[$1]}" &> /dev/null
   exit 0
else
   echo "${!BOOKMARK_DICT[*]}"
fi
