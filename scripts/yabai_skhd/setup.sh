#!/usr/bin/env bash

set -eu

setup_yabai_skhd() {
    title "Setting up yabai & skhd"

    info "Creating symlink for yabai & skhd"
    ln -sfn "${CONFIGS_DIR}/yabai" "${XDG_CONFIG_HOME}/yabai"
    ln -sfn "${CONFIGS_DIR}/skhd" "${XDG_CONFIG_HOME}/skhd"

    yabai --start-service
    yabai --restart-service
    skhd --start-service
    skhd --restart-service
}
