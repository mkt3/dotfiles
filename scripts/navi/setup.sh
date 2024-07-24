#!/usr/bin/env bash

set -eu

post_setup_navi() {
    local navi_dir="$CONFIGS_DIR/navi"

    info "Creating symlink for navi"
    ln -sfn "$navi_dir" "${XDG_CONFIG_HOME}/navi"
}
