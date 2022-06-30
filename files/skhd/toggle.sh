#!/bin/bash

osascript -e "tell application \"$1\" to run" \
  -e "tell application \"System Events\"" \
  -e "if visible of application process \"$1\" is true then" \
  -e "set visible of application process \"$1\" to false" \
  -e "else" \
  -e "set visible of application process \"$1\" to true" \
  -e "tell application \"$1\" to activate" \
  -e "end if" \
  -e "end tell"
