#!/usr/bin/env bash

set -eu

setup_macos() {
    title "Setting up macos"

    if [ ! -e "/Library/Developer/CommandLineTools/" ]; then
        info "Installing xcode-select"
        xcode-select --install
    fi

    info "Changing macos config"
    bash -l "${CONFIGS_DIR}/macos/setup_macOS.sh"
}
