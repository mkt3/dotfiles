#!/usr/bin/env bash

set -eu

setup_emacs() {
    title "Setting up emacs"
    local emacs_file_dir="$CONFIGS_DIR/emacs"
    local skk_record_file="${XDG_CONFIG_HOME}/emacs/ddskk.d/skk-record"
    info "Creating symlink for emacs"
    ln -sfn $emacs_file_dir "${XDG_CONFIG_HOME}/emacs"

    if [ ! -e $skk_record_file ];then
        touch $skk_record_file
    fi
}
