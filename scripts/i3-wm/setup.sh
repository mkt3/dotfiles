#!/usr/bin/env bash

set -eu

setup_i3-wm() {
    title "Setting up i3-wm"
    local i3wm_file_dir="${CONFIGS_DIR}/i3-wm"

    info "Creating symlink for i3"
    ln -sfn "${i3wm_file_dir}/i3" "${XDG_CONFIG_HOME}"

    info "Creating symlink for i3blocks"
    ln -sfn "${i3wm_file_dir}/i3blocks" "${XDG_CONFIG_HOME}"

    info "Creating symlink for rofi"
    ln -sfn "${i3wm_file_dir}/rofi" "${XDG_CONFIG_HOME}"

    info "Creating symlink for blight.sh"
    ln -sfn "${i3wm_file_dir}/blight.sh" "${HOME}/.local/bin/"
}
