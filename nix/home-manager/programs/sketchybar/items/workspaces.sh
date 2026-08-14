#!/usr/bin/env bash

PLUGIN_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/sketchybar/plugins"
STATE_DIR="/tmp/sketchybar-omniwm-${UID}"

# The hidden observer turns OmniWM IPC notifications into targeted item
# updates; reloading the whole bar is never necessary.
sketchybar --add event omniwm_refresh                              \
           --add item omniwm.observer left                        \
           --set omniwm.observer drawing=off                      \
                                  script="$PLUGIN_DIR/omniwm/refresh.sh" \
           --subscribe omniwm.observer omniwm_refresh

# Populate immediately, then start the event-driven watcher. The watcher also
# requests an initial event, so a state change during startup is not missed.
# SketchyBar removes dynamic items on reload, so invalidate the persisted item
# inventory and force refresh.sh to recreate them.
mkdir -p "$STATE_DIR"
rm -f "$STATE_DIR/workspaces.json"
sketchybar --trigger omniwm_refresh
"$PLUGIN_DIR/omniwm/start.sh"
