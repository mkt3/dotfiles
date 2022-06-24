#!/usr/bin/env bash

set -eu

setup_ripgrep() {
    title "Setting up ripgrep"

    info "Creating symlink for ripgrep"
    ln -sfn "${CONFIGS_DIR}/ripgrep" "${XDG_CONFIG_HOME}/ripgrep"
}
