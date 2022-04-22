#!/usr/bin/env bash

set -eu

setup_tmux() {
    title "Setting up tmux"
    local tmux_dir="$CONFIGS_DIR/tmux"

    info "Creating symlink for tmux"
    ln -sfn ${tmux_dir} "${XDG_CONFIG_HOME}/tmux"
}
