#!/usr/bin/env bash

set -eu

setup_vim() {
    title "Setting up vim"
    local vim_file_dir="$CONFIGS_DIR/vim"

    info "Creating symlink for vim"

    ln -sfn $vim_file_dir "${XDG_CONFIG_HOME}/vim"
}
