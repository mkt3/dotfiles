#!/bin/bash

## If you don't want the script to automatically choose the Chrome version to
## use, set the CHROME_VERSION variable below
CHROME_VERSION=""

# Chrome version is not set, the script will try to locate it by looping through
# all the possible chrome versions and checking if its user data dir exists
if [ -z "$CHROME_VERSION" ]; then
    CHROME_VERSIONS=(
        "chromium"
        "google-chrome"
        "google-chrome-beta"
        "google-chrome-unstable"
    )
    for version in "${CHROME_VERSIONS[@]}"; do
        if [ -d "$HOME/.config/$version" ]; then
            CHROME_VERSION="$version"
            break
        fi
    done
fi

# Chrome version was not set and it could not be automatically found either
if [ -z "$CHROME_VERSION" ]; then
    echo "unable to find Chrome version"
    exit 1
fi

# Check if the user data dir actually exists
CHROME_USER_DATA_DIR="$HOME/.config/$CHROME_VERSION"
if [ ! -d "$CHROME_USER_DATA_DIR" ]; then
    echo "unable to find Chrome user data dir"
    exit 1
fi

# Run a python script to read profiles data from an state file used by Chrome
DATA=$(python << END
import json
with open("$CHROME_USER_DATA_DIR/Local State") as f:
    data = json.load(f)

# print(data["profile"]["info_cache"])
for profile in data["profile"]["info_cache"]:
    print("%s_____%s" % (profile, data["profile"]["info_cache"][profile]["name"]))
END
)

# Populate an associative array that maps profiles names to directories
declare -A profiles=()
while read -r line
do
    PROFILE="${line%_____*}"
    NAME="${line#*_____}"
    profiles["$NAME"]="$PROFILE"
done <<< "$DATA"

if [ -z "$@" ]; then
    # No argument passed, meaning that rofi was launched: show the profiles
    for profile in "${!profiles[@]}"; do
        echo $profile
    done
else
    # One argument passed, meaning that user selected a profile: launch Chrome
    NAME="${@}"
    google-chrome-stable --profile-directory="${profiles[$NAME]}" > /dev/null 2>&1
fi
