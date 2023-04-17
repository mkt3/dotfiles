#!/usr/bin/env bash

set -eu

setup_rtx() {
    title "Setting up rtx"

    local rtx_dir="$CONFIGS_DIR/rtx"

    info "Creating symlink for rtx"
    ln -sfn "$rtx_dir" "${XDG_CONFIG_HOME}"

    info "Installing rtx"
    "${CARGO_HOME}/bin/rustup" run stable cargo install rtx-cli

    info "Linking completion"
    "${CARGO_HOME}/bin/rtx" completion zsh > "${ZSH_COMPLETION_DIR}/_rtx"
}
