#!/usr/bin/env bash

set -eu

pre_setup_zsh() {
    local zsh_file_dir="${CONFIGS_DIR}/zsh"

    info "Creating symlink for zsh"

    ln -sfn "${zsh_file_dir}/zshenv.zsh" "${HOME}/.zshenv"
    ln -sfn "$zsh_file_dir" "${XDG_CONFIG_HOME}/zsh"

    info "Creating zsh history dir"
    mkdir -p "${XDG_STATE_HOME}/zsh"

    info "Creating zsh completion dir"
    mkdir -p "$ZSH_COMPLETION_DIR"

    ln -sfn "${zsh_file_dir}/tmux_session.sh" "${HOME}/.local/bin/"

}
