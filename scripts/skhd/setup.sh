#!/usr/bin/env bash

set -eu

pre_setup_skhd() {
    info "Creating symlink for skhd"
    ln -sfn "${CONFIGS_DIR}/skhd" "${XDG_CONFIG_HOME}/skhd"
}

post_setup_skhd() {
    info "Restart skhd"
    skhd --start-service
    skhd --restart-service
}
