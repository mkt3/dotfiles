#!/usr/bin/env bash

set -eu

setup_autorandr() {
    title "Setting up autorandr"
    local autorandr_file_dir="${CONFIGS_DIR}/autorandr"

    info "Creating symlink for autorandr"
    ln -sfn $autorandr_file_dir $XDG_CONFIG_HOME
}
