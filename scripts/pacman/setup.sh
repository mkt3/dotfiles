#!/usr/bin/env bash

set -eu

setup_pacman() {
    title "Setting up pacman"

    package_list=(python \
                  python-pipx
                      )

    info "Installing packages"
    sudo pacman -S ${package_list[@]} --noconfirm
}
