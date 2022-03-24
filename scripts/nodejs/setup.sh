#!/usr/bin/env bash

set -eu

setup_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    . "${XDG_CONFIG_HOME}/nvm/nvm.sh" && nvm install --lts --latest-npm && nvm alias default 'lts/*'

}

setup_nodejs() {
    title "Setting up nodejs"

    setup_nvm

    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"

}
