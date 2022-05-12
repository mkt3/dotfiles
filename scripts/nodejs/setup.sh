#!/usr/bin/env bash

set -eu

setup_nvm() {
    NVM_VERSION="v16.15.0"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    . "${XDG_CONFIG_HOME}/nvm/nvm.sh" && nvm install --lts --latest-npm $NVM_VERSION && nvm alias default $NVM_VERSION

    if [ -e "${HOME}/.profile" ]; then
        rm -rf "${HOME}/.profile"
    fi

    ln -sfn "${XDG_CONFIG_HOME}/nvm/versions/node/${NVM_VERSION}" "${XDG_CONFIG_HOME}/nvm/versions/node/default"
}

setup_nodejs() {
    title "Setting up nodejs"

    setup_nvm

    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"

}
