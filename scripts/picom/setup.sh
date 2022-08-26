#!/usr/bin/env bash

set -eu

setup_picom() {
    title "Setting up picom"
    local picom_file_dir="${CONFIGS_DIR}/picom"

    info "Installing picom"
    install_pacman_package picom

    info "Creating symlink for picom"
    ln -sfn $picom_file_dir $XDG_CONFIG_HOME
}
