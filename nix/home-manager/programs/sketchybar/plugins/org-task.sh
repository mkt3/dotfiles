#!/usr/bin/env bash

TASK_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/emacs/org-clock-current-task.txt"
TASK=$(cat "$TASK_FILE" 2>/dev/null || true)

if [[ "$TASK" != "" ]]; then
    ICON=""
	  LABEL="$TASK"
else
    ICON="󰀦"
	  LABEL="No assigned task"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
