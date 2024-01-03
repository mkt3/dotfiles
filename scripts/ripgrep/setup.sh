#!/usr/bin/env bash

set -eu

pre_setup_ripgrep() {

    info "Creating symlink for ripgrep"
    ln -sfn "${CONFIGS_DIR}/ripgrep" "${XDG_CONFIG_HOME}/ripgrep"
}
