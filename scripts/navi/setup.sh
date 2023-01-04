#!/usr/bin/env bash

set -eu

setup_navi() {
    title "Setting up navi"
    local navi_dir="$CONFIGS_DIR/navi"

    "${CARGO_HOME}/bin/rustup" run stable cargo install navi

    info "Creating symlink for navi"
    ln -sfn "$navi_dir" "${XDG_CONFIG_HOME}/navi"

    local mac_config_dir="${HOME}/Library/Application Support"
    if [ -e "${mac_config_dir}" ]; then
        eval "ln -sfn ${navi_dir} \"${mac_config_dir}/navi\""
    fi

}
