#!/usr/bin/env bash

set -eu

pre_setup_rtx() {
    title "Pre setting up rtx"

    local rtx_dir="$CONFIGS_DIR/rtx"

    info "Creating symlink for rtx"
    ln -sfn "$rtx_dir" "${XDG_CONFIG_HOME}"

    info "Linking completion"
    "${CARGO_HOME}/bin/rtx" completion zsh > "${ZSH_COMPLETION_DIR}/_rtx"
}

post_setup_rtx() {
    title "Post setting up rtx"
    info "Linking completion"
    "${CARGO_HOME}/bin/rtx" completion zsh > "${ZSH_COMPLETION_DIR}/_rtx"
}
