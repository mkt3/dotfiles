#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_dir="$CONFIGS_DIR/nix"
    local home_manager_dir="${nix_dir}/home-manager"

    mkdir -p "${XDG_CONFIG_HOME}/nix"
    ln -sfn "${nix_dir}/nix.conf" "${XDG_CONFIG_HOME}/nix/"

    ln -sfn "$home_manager_dir" "${XDG_CONFIG_HOME}/"
}
