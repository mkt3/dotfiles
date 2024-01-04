#!/usr/bin/env bash

set -eu

pre_setup_kanshi() {
    local kanshi_file_dir="${CONFIGS_DIR}/kanshi"

    info "Creating symlink for kanshi"
    ln -sfn "${kanshi_file_dir}" "${XDG_CONFIG_HOME}"

    info "Adding kanshi service"
    ln -sfn "${kanshi_file_dir}/kanshi.service" "${XDG_CONFIG_HOME}/systemd/user/"
}
