#!/usr/bin/env bash

set -eu

setup_tig() {
    title "Setting up tig"

    info "Creating symlink for tig"
    ln -sfn "${CONFIGS_DIR}/tig" "${XDG_CONFIG_HOME}/tig"

    info "Creating tig data dir"
    mkdir -p "${XDG_DATA_HOME}/tig"

}
