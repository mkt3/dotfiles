#!/usr/bin/env bash

set -eu

pre_setup_npm() {
    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"
}
