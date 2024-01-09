#!/usr/bin/env bash

set -eu

pre_setup_borg() {
    local borg_file_dir="${CONFIGS_DIR}/borg"

    info "Creating symlink for borg"
    ln -sfn "$borg_file_dir" "$XDG_CONFIG_HOME"

    info "Adding systemd"
    mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
    ln -sfn "${borg_file_dir}/borg.service" "${XDG_CONFIG_HOME}/systemd/user/"
    ln -sfn "${borg_file_dir}/borg.timer" "${XDG_CONFIG_HOME}/systemd/user/"
}
