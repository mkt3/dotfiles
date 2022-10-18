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
                          jq \
                          neofetch \
                          zip \
                          unzip \
                          rsync \
                          httpie \
                          unarchiver \
                          cmake
                     )

    gui_pacman_package_list=(sway \
                          xorg-xwayland \
                          qt5-wayland \ 
                          swayidle \
                          swaylock \
                          swaybg \
                          waybar \
                          wl-clipboard \
                          rofi \
                          mako \
                          lightdm \
                          lightdm-gtk-greeter \
                          network-manager-applet \
                          networkmanager-openvpn \
                          noto-fonts \
                          noto-fonts-cjk \
                          noto-fonts-emoji \
                          noto-fonts-extra \
                          ttf-font-awesome \
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
                          pavucontrol \
                          thunar \
                          gvfs \
                          gvfs-smb \
                          sshfs \
                          emacs-nativecomp \
                          texlive-core \
                          wezterm \
                          nextcloud-client \
                          qtkeychain-qt5 \
                          libsecret \
                          gnome-keyring \
                          seahorse \
                          discord \
                          firefox \
                          thunderbird \
                          acpi \
                          sysstat \
                          libreoffice-fresh \
                          jupyterlab \
                          hugo
                            )
    gui_aur_package_list=(enpass-bin \
                              autotiling \
                              zoom \
                              slack-desktop \
                              google-chrome \
                              anki-official-binary-bundle \
                              nwg-look \
                              nordic-theme \
                              ddcci-driver-linux-dkms \
                              clipman
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
