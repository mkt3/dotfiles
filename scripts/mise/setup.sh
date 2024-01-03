#!/usr/bin/env bash

set -eu

pre_setup_mise() {

    local mise_dir="$CONFIGS_DIR/mise"

    info "Creating symlink for mise"
    ln -sfn "$mise_dir" "${XDG_CONFIG_HOME}"
}

post_setup_mise() {
    info "Linking completion"
    "${CARGO_HOME}/bin/mise" completion zsh > "${ZSH_COMPLETION_DIR}/_mise"
}
