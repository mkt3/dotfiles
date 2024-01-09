#!/usr/bin/env bash

set -eu

pre_setup_karabiner() {

    info "Creating symlink for karabiner"
    ln -sfn "${CONFIGS_DIR}/karabiner" "${XDG_CONFIG_HOME}/karabiner"
}
