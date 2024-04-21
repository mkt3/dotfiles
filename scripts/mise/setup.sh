#!/usr/bin/env bash

set -eu

pre_setup_mise() {

    local mise_dir="$CONFIGS_DIR/mise"

    info "Creating symlink for mise"
    ln -sfn "$mise_dir" "${XDG_CONFIG_HOME}"
}

post_setup_mise() {
    info "Linking completion"
    if (type mise > /dev/null 2>&1); then
        mise completion zsh > "${ZSH_COMPLETION_DIR}/_mise"
    fi
}
