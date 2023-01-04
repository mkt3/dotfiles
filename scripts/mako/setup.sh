#!/usr/bin/env bash

set -eu

setup_mako() {
    title "Setting up mako"
    local mako_file_dir="${CONFIGS_DIR}/mako"

    info "Creating symlink for mako"
    ln -sfn "$mako_file_dir" "$XDG_CONFIG_HOME"
}
