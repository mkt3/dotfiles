#!/usr/bin/env bash

set -eu

setup_homebrew() {
    title "Setting up homebrew"

    info "Creating symlink for Brewfile"
    mkdir -p "$XDG_CONFIG_HOME"
    ln -sfn "${CONFIGS_DIR}/homebrew" "${XDG_CONFIG_HOME}/homebrew"

    if ! (type brew > /dev/null 2>&1); then
        info "Installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        info "Updating homebrew"
        brew update
    fi

    info "Installing apps"
    brew bundle

    info "Updating apps"
    brew upgrade
    brew cleanup
}
