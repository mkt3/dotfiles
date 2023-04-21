#!/usr/bin/env bash

set -eu

setup_lazygit() {
    title "Setting up lazygit"

    info "Installing lazygit"
    go install github.com/jesseduffield/lazygit@latest

    mkdir -p "${XDG_CONFIG_HOME}/lazygit"
    info "Creating symlink for lazygit"
    ln -sfn "${CONFIGS_DIR}/lazygit/config.yml" "${XDG_CONFIG_HOME}/lazygit/"
}
