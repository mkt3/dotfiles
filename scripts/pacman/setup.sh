#!/usr/bin/env bash

set -eu

setup_pacman() {
    title "Setting up pacman"

    installed_package=`sudo pacman -Qe`
    package_list=(python \
                  python-pip \
                  python-pipx \
                  lazygit \
                  zsh \
                  tmux \
                  go \
                  duf \
                  rsync
                      )

    for package in ${package_list[@]}; do
        if [ "$(echo "${installed_package}" | grep "^${package} " )" ] ;then
            info "${package} already installed"
        else
            info "Installing ${package}"
            sudo pacman -S $package --noconfirm
        fi
    done
}
