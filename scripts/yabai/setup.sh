#!/usr/bin/env bash

set -eu

pre_setup_yabai() {
    info "Creating symlink for yabai"
    ln -sfn "${CONFIGS_DIR}/yabai" "${XDG_CONFIG_HOME}/yabai"
}

post_setup_yabai() {
    info "Restart yabai"
    yabai --start-service
    yabai --restart-service
}
