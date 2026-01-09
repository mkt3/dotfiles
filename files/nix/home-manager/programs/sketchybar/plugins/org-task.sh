#!/usr/bin/env bash

TASK=$(cat "${XDG_CONFIG_HOME:-${HOME}/.config}/emacs/org-clock-current-task.txt" 2>/dev/null || true)

if [[ "$TASK" != "" ]]; then
    ICON=""
	  LABEL="$TASK"
else
    ICON="󰀦"
	  LABEL="No assigned task"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
