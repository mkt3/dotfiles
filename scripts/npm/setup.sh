#!/usr/bin/env bash

set -eu

pre_setup_npm() {
    title "Pre setting up npm"
    info "Creating symlink for npm"
    ## npm conf
    ln -sfn "${CONFIGS_DIR}/files/npm" "${XDG_CONFIG_HOME}/npm"
}

post_setup_npm() {
    title "Post setting up npm"

    npm config set prefix "${XDG_DATA_HOME}/npm"
}
