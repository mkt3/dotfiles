#!/usr/bin/env bash

set -eu

setup_emacs() {
    title "Setting up emacs"
    local emacs_file_dir="$CONFIGS_DIR/emacs"
    local skk_record_file="${XDG_CONFIG_HOME}/emacs/ddskk.d/skk-record"

    mkdir -p "${XDG_CONFIG_HOME}/emacs/ddskk.d"
    info "Creating symlink for emacs"
    ln -sfn "${emacs_file_dir}/README.org" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/init.el" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/snippets" "${XDG_CONFIG_HOME}/emacs/"

    if [ ! -e $skk_record_file ];then
        touch $skk_record_file
    fi
}
