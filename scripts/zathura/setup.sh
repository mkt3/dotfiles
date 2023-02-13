#!/usr/bin/env bash

set -eu

setup_zathura() {
    title "Setting up zathura"
    local zathura_file_dir="${CONFIGS_DIR}/zathura"

    info "Creating symlink for zathura"
    ln -sfn "$zathura_file_dir" "$XDG_CONFIG_HOME"
}
