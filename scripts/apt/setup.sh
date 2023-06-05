#!/usr/bin/env bash

set -eu

setup_apt() {
    title "Setting up apt"

    package_list=(build-essential
                  zsh
                  locales
                  cmake
                  jq
                  unar
                  vim
                  duf
                  htop
                  iotop
                  nvtop
                  neofetch
                  golang
                  libbz2-dev
                  libdb-dev
                  libreadline-dev
                  libffi-dev
                  libgdbm-dev
                  liblzma-dev
                  libncursesw5-dev
                  libsqlite3-dev
                  libssl-dev
                  zlib1g-dev
                  uuid-dev
                  python3-dev
                  python3-venv
                  python3-pip
                  trash-cli
                  axel
                  tk-dev)

    info "Installing packages"
    sudo apt -y install "${package_list[@]}"

    info "Creating locale"
    sudo locale-gen en_US.UTF-8
    sudo locale-gen ja_JP.UTF-8

}
