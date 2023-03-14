#!/usr/bin/env bash

set -eu
install_pacman_package() {
    package=$1
    if sudo pacman -Qs "$package" | grep -q "^local/${package} " ;then
        info "${package}(pacman) already installed"
    else
        info "Installing ${package}(pacman)"
        sudo pacman -S "$package" --noconfirm
     fi
}

install_aur_package() {
    package=$1
    if yay -Qs "$package" | grep -q "^local/${package} " ;then
        info "${package}(aur) already installed"
    else
        info "Installing ${package}(aur)"
        yay -S "$package" --noconfirm
     fi
}

setup_pacman() {
    title "Setting up pacman"

    cui_pacman_package_list=(python \
                          python-pip \
                          python-pipx \
                          openssl \
                          zlib \
                          xz \
                          tk \
                          zsh \
                          tmux \
                          pacman-contrib \
                          go \
                          duf \
                          htop \
                          iotop \
                          sysstat \
                          jq \
                          neofetch \
                          rsync \
                          httpie \
                          axel \
                          unarchiver \
                          cmake \
                          gnupg \
                          shellcheck
                     )

    gui_pacman_package_list=(sway \
                          xorg-xwayland \
                          qt5-wayland \
                          qt6-wayland \
                          swayidle \
                          swaylock \
                          swaybg \
                          xdg-desktop-portal-wlr \
                          xdg-desktop-portal \
                          waybar \
                          wl-clipboard \
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
                          bluez \
                          bluez-utils \
                          blueman \
                          fcitx5 \
                          fcitx5-configtool \
                          fcitx5-gtk \
                          fcitx5-qt \
                          fcitx5-skk \
                          fcitx5-nord \
                          pipewire \
                          wireplumber \
                          pipewire-alsa \
                          pipewire-pulse \
                          pavucontrol \
                          playerctl \
                          thunar \
                          tumbler \
                          gvfs \
                          gvfs-smb \
                          sshfs \
                          ristretto \
                          slurp \
                          grim \
                          kanshi \
                          emacs-nativecomp \
                          texlive-core \
                          wezterm \
                          nextcloud-client \
                          qtkeychain-qt5 \
                          libsecret \
                          gnome-keyring \
                          seahorse \
                          gtk2 \
                          discord \
                          vivaldi \
                          vivaldi-ffmpeg-codecs \
                          firefox \
                          acpi \
                          libreoffice-fresh \
                          hugo \
                          vlc \
                          libdvdread \
                          libdvdnav \
                          libdvdcss \
                          borg \
                          zathura \
                          zathura-pdf-mupdf \
                          isync \
                          kdeconnect \
                          dvd+rw-tools
                            )
    gui_aur_package_list=(enpass-bin \
                              slack-desktop \
                              google-chrome \
                              anki-official-binary-bundle \
                              autotiling \
                              nwg-look \
                              nordic-theme \
                              ddcci-driver-linux-dkms \
                              clipman \
                              mu
                         )

    for package in "${cui_pacman_package_list[@]}"; do
        install_pacman_package "$package"
    done

    if [ "$1" = "gui" ]; then
        for package in "${gui_pacman_package_list[@]}"; do
            install_pacman_package "$package"
        done
        for package in "${gui_aur_package_list[@]}"; do
            install_aur_package "$package"
        done
        # for rofi
        package=rofi-lbonn-wayland
        if yay -Qs "$package" | grep -q "^local/${package} "; then
            info "${package}(aur) already installed"
        else
        info "Installing ${package}(aur)"
        yay -S $package --noconfirm --mflags "--nocheck"
     fi
    fi
}
