#!/usr/bin/env bash

set -eu

pre_setup_hyprland() {
    local hyprland_file_dir="${CONFIGS_DIR}/hyprland"

    info "Creating symlink for hyprland"
    ln -sfn "${hyprland_file_dir}" "${XDG_CONFIG_HOME}/hypr"
}
