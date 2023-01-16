#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

setup_nvm() {
    NVM_VERSION="v18.12.1"
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

    installed_package=$(npm ls --location=global)
    package="bash-language-server"
    if echo "$installed_package" | grep -q "$package"; then
        info "$package updating..."
        npm update --location=global "$package"
    else
        info "$package installting..."
        npm install --location=global "$package"
    fi
}
