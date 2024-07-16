#!/usr/bin/env bash

set -eu

pre_setup_sketchybar() {
    info "Creating symlink for skhetchybar"
    ln -sfn "${CONFIGS_DIR}/sketchybar" "${XDG_CONFIG_HOME}/sketchybar"
}
