#!/usr/bin/env bash

set -eu

post_setup_macos() {
    macos_configured_flag="${REPO_DIR}/results/macos_configured_flag"
    if [[ -f "$macos_configured_flag" ]]; then
        info "Skipping as the macOS settings have already been applied."
    else
        info "Changing macos config"
        bash -l "${CONFIGS_DIR}/macos/setup_macOS.sh"
        touch "$macos_configured_flag"
    fi

    if command -v brew > /dev/null; then
        bash -l "${CONFIGS_DIR}/macos/install-pam_tid-and-pam_reattach.sh"
    fi

    info "Creating symlink for samba"
    ln -sfn "${CONFIGS_DIR}/macos/nsmb.conf" "${HOME}/Library/Preferences/nsmb.conf"
}
