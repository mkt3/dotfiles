#!/usr/bin/env bash

set -eu
install_pacman_package() {
    package=$1
    if [ "$(sudo pacman -Qs ${package} | grep "^local/${package} " )" ] ;then
        info "${package}(pacman) already installed"
    else
        info "Installing ${package}(pacman)"
        sudo pacman -S $package --noconfirm
     fi
}

install_aur_package() {
    package=$1
    if [ "$(yay -Qs ${package} | grep "^local/${package} " )" ] ;then
        info "${package}(aur) already installed"
    else
        info "Installing ${package}(aur)"
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
                          pacman-contrib \
                          go \
                          duf \
                          htop \
                          iotop \
                          neofetch \
                          zip \
                          unzip \
                          rsync \
                          httpie \
                          unarchiver \
                          cmake
                     )

    gui_pacman_package_list=(xorg-server \
                          lightdm \
                          lightdm-gtk-greeter \
                          light-locker \
                          dex \
                          network-manager-applet \
                          networkmanager-openvpn \
                          noto-fonts \
                          noto-fonts-cjk \
                          noto-fonts-emoji \
                          noto-fonts-extra \
                          ttf-font-awesome \
                          adapta-gtk-theme \
                          papirus-icon-theme \
                          fcitx5 \
                          fcitx5-configtool \
                          fcitx5-gtk \
                          fcitx5-qt \
                          fcitx5-skk \
                          pipewire \
                          wireplumber \
                          pipewire-alsa \
                          pipewire-pulse \
                          thunar \
                          gvfs \
                          gvfs-smb \
                          sshfs \
                          emacs-nativecomp \
                          texlive-core \
                          wezterm \
                          picom \
                          dunst \
                          i3-gaps \
                          i3blocks \
                          rofi \
                          nextcloud-client \
                          qtkeychain-qt5 \
                          libsecret \
                          gnome-keyring \
                          seahorse \
                          volumeicon \
                          autorandr \
                          gnome-screenshot \
                          discord \
                          firefox \
                          thunderbird \
                          acpi \
                          sysstat \
                          xclip \
                          libreoffice-fresh \
                          jupyterlab \
                          hugo
                            )
    gui_aur_package_list=(xremap-x11-bin \
                              enpass-bin \
                              autotiling \
                              zoom \
                              slack-desktop \
                              google-chrome \
                              anki-official-binary-bundle \
                              rofi-greenclip
                         )

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
