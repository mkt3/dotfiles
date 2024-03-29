#!/usr/bin/env bash

set -eu

post_setup_navi() {
    local navi_dir="$CONFIGS_DIR/navi"

    info "Creating symlink for navi"
    ln -sfn "$navi_dir" "${XDG_CONFIG_HOME}/navi"

    if [ "$OS" = "Darwin" ]; then
        eval "ln -sfn ${navi_dir} \"${HOME}/Library/Application Support/navi\""
    fi

}
