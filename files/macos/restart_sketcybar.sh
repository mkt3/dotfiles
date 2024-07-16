#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title sketcybar
# @raycast.mode silent

# Optional parameters:

. "${HOME}/.zshenv"

launchctl kickstart -k gui/$(id -u)/org.nixos.sketchybar
