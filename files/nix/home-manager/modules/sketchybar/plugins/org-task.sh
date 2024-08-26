#!/usr/bin/env bash

TASK=$(cat ~/.config/emacs/org-clock-current-task.txt)

if [[ "$TASK" != "" ]]; then
    ICON=""
	  LABEL="$TASK"
else
    ICON="󰀦"
	  LABEL="No assigned task"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
