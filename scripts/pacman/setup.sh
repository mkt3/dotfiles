#!/usr/bin/env bash

set -eu

setup_pacman() {
    title "Setting up pacman"
    local cui_pacman_package_list=(python
                                   python-pip
                                   python-pipx
                                   openssl
                                   zlib
                                   xz
                                   tk
                                   zsh
                                   tmux
                                   pacman-contrib
                                   go
                                   duf
                                   htop
                                   iotop
                                   nvtop
                                   sysstat
                                   jq
                                   neofetch
                                   rsync
                                   httpie
                                   aria2
                                   unarchiver
                                   cmake
                                   gnupg
                                   shellcheck
                                   trash-cli
                                   bc
                                  )

    local gui_pacman_package_list=(sway
                                   xorg-xwayland
                                   qt5-wayland
                                   qt6-wayland
                                   swayidle
                                   swaylock
                                   swaybg
                                   xdg-desktop-portal-wlr
                                   xdg-desktop-portal
                                   waybar
                                   wl-clipboard
                                   mako
                                   lightdm
                                   lightdm-gtk-greeter
                                   network-manager-applet
                                   networkmanager-openvpn
                                   noto-fonts
                                   noto-fonts-cjk
                                   noto-fonts-emoji
                                   noto-fonts-extra
                                   ttf-font-awesome
                                   papirus-icon-theme
                                   bluez
                                   bluez-utils
                                   blueman
                                   fcitx5
                                   fcitx5-configtool
                                   fcitx5-gtk
                                   fcitx5-qt
                                   fcitx5-skk
                                   fcitx5-nord
                                   pipewire
                                   wireplumber
                                   pipewire-alsa
                                   pipewire-pulse
                                   pavucontrol
                                   playerctl
                                   thunar
                                   tumbler
                                   gvfs
                                   gvfs-smb
                                   sshfs
                                   ristretto
                                   slurp
                                   grim
                                   kanshi
                                   texlive
                                   wezterm
                                   nextcloud-client
                                   qtkeychain-qt5
                                   libsecret
                                   gnome-keyring
                                   seahorse
                                   gtk2
                                   discord
                                   vivaldi
                                   vivaldi-ffmpeg-codecs
                                   firefox
                                   acpi
                                   libreoffice-fresh
                                   hugo
                                   vlc
                                   libdvdread
                                   libdvdnav
                                   libdvdcss
                                   borg
                                   zathura
                                   zathura-pdf-mupdf
                                   msmtp        # for mu4e
                                   isync        # for mu4e
                                   goimapnotify # for mu4e
                                   imagemagick  # for dirvish
                                   kdeconnect
                                   dvd+rw-tools
                                   bitwarden
                                   python-i3ipc  # for inactive-windows-transparency.py
                                   autotiling-rs
                                  )

    # local cui_aur_package_list=""

    local gui_aur_package_list=(rofi-lbonn-wayland-git
                                slack-desktop
                                google-chrome
                                anki-official-binary-bundle
                                nwg-look
                                nordic-theme
                                ddcci-driver-linux-dkms
                                clipman
                                mu # for mu4e
                                zotero-bin
                               )


    if [ "$UI" = "gui" ]; then
        info "Installing packages(pacman)"
        sudo pacman -S --needed --noconfirm  "${cui_pacman_package_list[@]}" "${gui_pacman_package_list[@]}"
        info "Installing packages(aur)"
        yay -S --needed --noconfirm "${gui_aur_package_list[@]}"
        #yay -S --needed --noconfirm "${cui_aur_package_list[@]}" "${gui_aur_package_list[@]}"
    else
        info "Installing packages(pacman)"
        sudo pacman -S --needed --noconfirm  "${cui_pacman_package_list[@]}"
        info "Installing packages(aur)"
        # yay -S --needed --noconfirm "${cui_aur_package_list[@]}"

    fi
}
