#!/usr/bin/env bash

set -eu

setup_i3-wm() {
    title "Setting up i3-wm"
    local i3wm_file_dir="${CONFIGS_DIR}/i3-wm"

    info "Installing i3 and creating symlink for i3"
    install_pacman_package i3-gaps
    ln -sfn "${i3wm_file_dir}/i3" "${XDG_CONFIG_HOME}"

    info "Installing i3blocks  and creating symlink for i3blocks"
    install_pacman_package i3blocks
    ln -sfn "${i3wm_file_dir}/i3blocks" "${XDG_CONFIG_HOME}"

    info "Installing rofi and creating symlink for rofi"
    install_pacman_package rofi
    ln -sfn "${i3wm_file_dir}/rofi" "${XDG_CONFIG_HOME}"
}
