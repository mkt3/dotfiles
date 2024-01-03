#!/usr/bin/env bash

set -eu

pre_setup_xwindow() {
    local xwindow_file_dir="${CONFIGS_DIR}/xwindow"

    info "Creating symlink for .xprofile"
    # for lightdm
    ln -sfn "${xwindow_file_dir}/xprofile" "${HOME}/.xprofile"

    info "Creating symlink for .Xdefaults"
    ln -sfn "${xwindow_file_dir}/Xdefaults" "${HOME}/.Xdefaults"
}
