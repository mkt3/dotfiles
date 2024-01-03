#!/usr/bin/env bash

set -eu

post_setup_macos() {

    info "Changing macos config"
    bash -l "${CONFIGS_DIR}/macos/setup_macOS.sh"

    if command -v brew > /dev/null; then
        bash -l "${CONFIGS_DIR}/macos/install-pam_tid-and-pam_reattach.sh"
    fi

    info "Creating symlink for samba"
    sudo ln -sfn "${CONFIGS_DIR}/macos/nsmb.conf" /etc/nsmb.conf
}
