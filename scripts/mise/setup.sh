#!/usr/bin/env bash

set -eu

pre_setup_mise() {
    title "Pre setting up mise"

    local mise_dir="$CONFIGS_DIR/mise"

    info "Creating symlink for mise"
    ln -sfn "$mise_dir" "${XDG_CONFIG_HOME}"

    info "Linking completion"
    "${CARGO_HOME}/bin/mise" completion zsh > "${ZSH_COMPLETION_DIR}/_mise"
}

post_setup_mise() {
    title "Post setting up mise"
    info "Linking completion"
    "${CARGO_HOME}/bin/mise" completion zsh > "${ZSH_COMPLETION_DIR}/_mise"
}
