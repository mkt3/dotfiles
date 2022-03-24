#!/usr/bin/env bash

set -eu

setup_karabiner() {
    title "Setting up karabiner"

    info "Creating symlink for karabiner"
    ln -sfn "${CONFIGS_DIR}/karabiner" "${XDG_CONFIG_HOME}/karabiner"
}
