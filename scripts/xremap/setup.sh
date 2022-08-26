#!/usr/bin/env bash

set -eu

setup_xremap() {
    title "Setting up xremap"
    local xremap_file_dir="${CONFIGS_DIR}/xremap"

    info "Installing xremap"
    install_aur_package xremap-x11-bin

    info "Creating symlink for xremap"
    ln -sfn $xremap_file_dir $XDG_CONFIG_HOME
}
