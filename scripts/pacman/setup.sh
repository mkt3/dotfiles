#!/usr/bin/env bash

set -eu
install_pacman_package() {
    package=$1
    if [ "$(sudo pacman -Qe ${package} | grep "^${package} " )" ] ;then
        info "${package} already installed"
    else
        info "Installing ${package}"
        sudo pacman -S $package --noconfirm
     fi
}

install_aur_package() {
    package=$1
    if [ "$(yay -Qe ${package} | grep "^${package} " )" ] ;then
        info "${package} already installed"
    else
        info "Installing ${package}"
        yay -S $package --noconfirm
     fi
}

setup_pacman() {
    title "Setting up pacman"

    package_list=(python \
                  python-pip \
                  python-pipx \
                  lazygit \
                  zsh \
                  tmux \
                  go \
                  duf \
                  htop \
                  iotop \
                  neofetch \
                  rsync
                      )

    for package in ${package_list[@]}; do
        install_pacman_package $package
    done
}
