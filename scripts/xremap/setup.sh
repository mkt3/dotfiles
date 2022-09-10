#!/usr/bin/env bash

set -eu

setup_xremap() {
    title "Setting up xremap"
    local xremap_file_dir="${CONFIGS_DIR}/xremap"

    info "Creating symlink for xremap"
    ln -sfn $xremap_file_dir $XDG_CONFIG_HOME

    info "Adding systemd"
    mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
    ln -sfn $xremap_file_dir/xremap.service "${XDG_CONFIG_HOME}/systemd/user/"

    info "Start/Enable"
    systemctl --user restart xremap
    systemctl --user enable xremap
}
