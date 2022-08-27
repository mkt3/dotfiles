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

    cui_pacman_package_list=(python \
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

    gui_pacman_package_list=(xorg-server \
                          lightdm \
                          lightdm-gtk-greeter \
                          emacs-nativecomp \
                          texlive-core \
                          wezterm \
                          picom \
                          i3-gaps \
                          i3blocks \
                          rofi
                            )
    gui_aur_package_list=(xremap-x11-bin)

    for package in ${cui_pacman_package_list[@]}; do
        install_pacman_package $package
    done

    if [ $1 = "gui" ]; then
        for package in ${gui_pacman_package_list[@]}; do
            install_pacman_package $package
        done
        for package in ${gui_aur_package_list[@]}; do
            install_aur_package $package
        done
    fi
}
