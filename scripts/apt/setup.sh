#!/usr/bin/env bash

set -eu

setup_apt() {
    title "Setting up apt"

    info "Add ppa:kelleyk/emacs"
    sudo apt update
    sudo apt -y upgrade
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:kelleyk/emacs

    info "apt update & upgrade"
    sudo apt update
    sudo apt -y upgrade

    package_list=(build-essential \
                  zsh \
                  duf \
                  tig \
                  jq \
                  xsel \
                  libbz2-dev \
                  libdb-dev \
                  libreadline-dev \
                  libffi-dev \
                  libgdbm-dev \
                  liblzma-dev \
                  libncursesw5-dev \
                  libsqlite3-dev \
                  libssl-dev \
                  zlib1g-dev \
                  uuid-dev \
                  tk-dev)

    if [ $1 = "cui" ]; then
        package_list+=(emacs27-nox)
    elif [ $1 = "gui" ]; then
        package_list+=(gnome-shell gnome-tweak-tool ibus-skk emacs27)
    fi

    info "Installing packages"
    sudo apt -y install ${package_list[@]}

    local duf_deb_path="/tmp/duf.deb"
    curl -fL -o $duf_deb_path https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb

    sudo apt install -y $duf_deb_path
}
