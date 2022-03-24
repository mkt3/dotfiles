#!/usr/bin/env bash

set -eu

setup_fzf() {
    title "Setting up fzf"

    local git_url="https://github.com/junegunn/fzf.git"
    local install_dir="${XDG_DATA_HOME}/fzf"

    if [ -d $install_dir ]; then
        info "Updating fzf repository"
        git -C $install_dir pull
    else
        info "Clonening fzf repository"
        git clone --depth 1 $git_url $install_dir
    fi

    info "Installing fzf"
    ${install_dir}/install --xdg --completion --key-bindings --no-update-rc --no-bash --no-fish
}
