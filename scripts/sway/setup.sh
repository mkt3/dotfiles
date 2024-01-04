#!/usr/bin/env bash

set -eu

pre_setup_sway() {
    local sway_file_dir="${CONFIGS_DIR}/sway"

    info "Creating symlink for sway"
    ln -sfn "${sway_file_dir}" "${XDG_CONFIG_HOME}"

    info "Adding sway-session.target"
    mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
    ln -sfn "${sway_file_dir}/sway-session.target" "${XDG_CONFIG_HOME}/systemd/user/"
}
