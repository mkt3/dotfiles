#!/usr/bin/env bash

set -eu

pre_setup_waybar() {
    info "Creating symlink for waybar"
    ln -sfn "${CONFIGS_DIR}/waybar" "${XDG_CONFIG_HOME}"
}
