#!/usr/bin/env bash

set -eu

setup_xwindow() {
    title "Setting up X window"
    local xwindow_file_dir="${CONFIGS_DIR}/xwindow"

    info "Installing x window and lightDM"
    install_pacman_package xorg-server lightdm lightdm-gtk-greeter

    info "Creating symlink for xprofile"
    ln -sfn "${xwindow_file_dir}/xprofile" "${HOME}/.xprofile"
}
