#!/usr/bin/env bash

set -eu

setup_dunst() {
    title "Setting up dunst"
    local dunst_file_dir="${CONFIGS_DIR}/dunst"

    info "Creating symlink for dunst"
    ln -sfn $dunst_file_dir $XDG_CONFIG_HOME
}
