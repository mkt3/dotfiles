#!/usr/bin/env bash

set -eu

setup_pacman() {
    title "Setting up pacman"

    installed_package=`sudo pacman -Qe`
    package_list=(python \
                  python-pip \
                  python-pipx
                      )

    info "Installing packages"
    for package in ${package_list[@]}; do
        if [ ! "$(echo ${installed_package} | grep "^${package} " )" ] ;then
            sudo pacman -S $package --noconfirm
        fi
    done
}
