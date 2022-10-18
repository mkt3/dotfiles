#!/usr/bin/env bash

set -eu

setup_xwindow() {
    title "Setting up X window"
    local xwindow_file_dir="${CONFIGS_DIR}/xwindow"

    info "Creating symlink for .xprofile"
    ln -sfn "${xwindow_file_dir}/xprofile" "${HOME}/.xprofile"

    info "Creating symlink for .Xdefaults"
    ln -sfn "${xwindow_file_dir}/Xdefaults" "${HOME}/.Xdefaults"
}
