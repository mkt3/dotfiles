#!/usr/bin/env bash

set -eu

setup_zsh() {
    title "Setting up zsh"
    local zsh_file_dir="${CONFIGS_DIR}/zsh"

    info "Creating symlink for zsh"

    ln -sfn "${zsh_file_dir}/zshenv.zsh" "${HOME}/.zshenv"
    ln -sfn "$zsh_file_dir" "${XDG_CONFIG_HOME}/zsh"

    info "Creating zsh history dir"
    mkdir -p "${XDG_STATE_HOME}/zsh"

    info "Creating zsh completion dir"
    mkdir -p "$ZSH_COMPLETION_DIR"

    if [ -d "$ZINIT_HOME" ]; then
        info "Updating zinit and plugins"
        zsh -c 'source "${ZINIT_HOME}/zinit.zsh" && zinit update --parallel'
    else
       info "Clonening zinit repository"
       git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi

    ln -sfn "${zsh_file_dir}/tmux_session.sh" "${HOME}/.local/bin/"

}
