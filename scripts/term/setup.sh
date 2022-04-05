#!/usr/bin/env bash

set -eu

setup_term() {
    title "Setting up term"
    local terminfo_dir="$XDG_DATA_HOME/terminfo"

    mkdir -p $terminfo_dir

    if  bash -lc "ls -R $terminfo_dir | grep xterm-24bit > /dev/null"; then
        info "xterm-24bit already exists... Skipping."
    else
        info "Creating xterm-24bit."
        tic -x -o $terminfo_dir "$CONFIGS_DIR/term/terminfo-24bit.src"
    fi
}
