#!/usr/bin/env bash

set -eu

setup_homebrew() {
    title "Setting up homebrew"

    info "Creating symlink for Brewfile"
    ln -sfn "${CONFIGS_DIR}/homebrew" "${XDG_CONFIG_HOME}/homebrew"

    info "Updating homebrew"
    brew update

    info "Installing apps"
    brew bundle
    
    info "Updating apps"
    brew upgrade
    brew cleanup
}
