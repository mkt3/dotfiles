#!/usr/bin/env bash

set -eu

setup_wezterm() {
    title "Setting up wezterm"
    local wezterm_file_dir="${CONFIGS_DIR}/wezterm"

    info "Creating symlink for wezterm"
    ln -sfn $wezterm_file_dir $XDG_CONFIG_HOME
}
