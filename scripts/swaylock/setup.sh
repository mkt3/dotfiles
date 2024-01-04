#!/usr/bin/env bash

set -eu

pre_setup_swaylock() {
    info "Creating symlink for swaylock"
    ln -sfn "${CONFIGS_DIR}/swaylock" "${XDG_CONFIG_HOME}"
}
