#!/usr/bin/env bash

set -eu

post_setup_yabai_skhd_sketchybar() {

    info "Creating symlink for yabai & skhd"
    ln -sfn "${CONFIGS_DIR}/yabai" "${XDG_CONFIG_HOME}/yabai"
    ln -sfn "${CONFIGS_DIR}/skhd" "${XDG_CONFIG_HOME}/skhd"
    ln -sfn "${CONFIGS_DIR}/sketchybar" "${XDG_CONFIG_HOME}/sketchybar"

    yabai --start-service
    yabai --restart-service
    skhd --start-service
    skhd --restart-service
    brew services start sketchybar
    brew services restart sketchybar
}
