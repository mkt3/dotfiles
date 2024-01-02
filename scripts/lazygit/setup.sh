#!/usr/bin/env bash

set -eu

pre_setup_lazygit() {
    title "Pre setting up lazygit"

    mkdir -p "${XDG_CONFIG_HOME}/lazygit"
    info "Creating symlink for lazygit"
    ln -sfn "${CONFIGS_DIR}/lazygit/config.yml" "${XDG_CONFIG_HOME}/lazygit/"
}
