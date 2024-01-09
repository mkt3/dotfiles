#!/usr/bin/env bash

set -eu

pre_setup_mako() {
    local mako_file_dir="${CONFIGS_DIR}/mako"

    info "Creating symlink for mako"
    ln -sfn "$mako_file_dir" "$XDG_CONFIG_HOME"
}
