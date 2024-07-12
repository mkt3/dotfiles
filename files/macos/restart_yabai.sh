#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yabai
# @raycast.mode silent

# Optional parameters:

. "${HOME}/.zshenv"

launchctl kickstart -k gui/$(id -u)/org.nixos.yabai
