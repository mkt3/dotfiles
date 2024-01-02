#!/usr/bin/env bash

set -eu

post_setup_vim() {
    title "Post setting up vim"
    local vim_file_dir="$CONFIGS_DIR/vim"

    info "Creating symlink for vim"
    ln -sfn "$vim_file_dir" "${XDG_CONFIG_HOME}/vim"
}
