#!/usr/bin/env bash

set -eu

setup_zsh() {
    title "Setting up zsh"
    local zsh_file_dir="${CONFIGS_DIR}/zsh"

    info "Creating symlink for zsh"

    ln -sfn "${zsh_file_dir}/.zshenv" "${HOME}/.zshenv"
    ln -sfn $zsh_file_dir "${XDG_CONFIG_HOME}/zsh"

    info "Creating zsh completion dir"
    mkdir -p $ZSH_COMPLETION_DIR
}
