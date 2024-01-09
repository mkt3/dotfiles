#!/usr/bin/env bash

set -eu

post_setup_xremap() {
    local xremap_file_dir="${CONFIGS_DIR}/xremap"

    info "Creating symlink for xremap"
    ln -sfn "$xremap_file_dir" "$XDG_CONFIG_HOME"

    info "Adding systemd"
    mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
    ln -sfn "${xremap_file_dir}/xremap.service" "${XDG_CONFIG_HOME}/systemd/user/"

    info "Enable xremap.service"
    systemctl --user enable xremap.service
}
