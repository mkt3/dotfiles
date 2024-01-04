#!/usr/bin/env bash

set -eu

pre_setup_rofi() {
    info "Creating symlink for rofi"
    ln -sfn "${CONFIGS_DIR}/rofi" "${XDG_CONFIG_HOME}"
}
