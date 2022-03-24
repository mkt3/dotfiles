#!/usr/bin/env bash

set -eu

setup_aquaskk() {
    title "Setting up aquaskk"

    local aquaskk_conf_dir="${HOME}/Library/Application Support/AquaSKK"
    info "Creating aquaskk dir"
    eval "mkdir -p \"${aquaskk_conf_dir}\""

    info "Creating symlink for aquaskk"
    eval "ln -sfn ${CONFIGS_DIR}/aquaskk/keymap.conf \"${aquaskk_conf_dir}/keymap.conf\""

}
