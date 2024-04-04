#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title sketcybar
# @raycast.mode silent

# Optional parameters:

. "${HOME}/.zshenv"

brew services restart sketchybar
