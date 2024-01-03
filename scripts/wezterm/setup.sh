#!/usr/bin/env bash

set -eu

pre_setup_wezterm() {
    local wezterm_file_dir="${CONFIGS_DIR}/wezterm"

    info "Creating symlink for wezterm"
    ln -sfn "$wezterm_file_dir" "$XDG_CONFIG_HOME"
}
