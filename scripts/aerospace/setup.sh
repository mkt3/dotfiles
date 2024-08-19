#!/usr/bin/env bash

set -eu

pre_setup_aerospace() {
    info "Creating symlink for aerospace"
    ln -sfn "${CONFIGS_DIR}/aerospace" "${XDG_CONFIG_HOME}/"
}
