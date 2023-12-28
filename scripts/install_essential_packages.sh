#!/usr/bin/env bash

set -eu
set -o pipefail

install_essential_packages() {
    case "$OS" in
        Darwin)
            install_macos
            ;;
        Linux)
            install_linux
            ;;
        *)
            echo "${OS} is not supported."
            exit 1
        ;;
    esac

    install_rust

}

install_macos() {
    if [ ! -e "/Library/Developer/CommandLineTools/" ]; then
        xcode-select --install
    fi

    if ! (type brew > /dev/null 2>&1); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
    fi

    if ! (type yj > /dev/null 2>&1); then
        brew install yj
    else
        brew upgrade yj
    fi
}

install_linux() {
    local distro
    distro=$(awk '{print $1; exit}' /etc/issue)

    # distribution
    case $distro in
        Arch)
            sudo pacman -S --needed --noconfirm git jq wget
            ;;
        Ubuntu)
            sudo apt-get -y install git jq wget
            ;;
        *)
            echo "${distro} is not supported."
            exit 1
    esac

    local yj_path="${HOME}/.local/bin/yj"
    wget https://github.com/sclevine/yj/releases/latest/download/yj-macos-amd64 -o "$yj_path"
    chomod +x "yj_path"

}

install_rust() {
    mkdir -p "$CARGO_HOME"
    ln -sfn "./files/rust/cargo/config" "${CARGO_HOME}/config"

    if (type rustup > /dev/null 2>&1); then
        rustup self update
        rustup update
    else
        info "Installing rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    fi

    "${CARGO_HOME}/bin/rustup" completions zsh > "${ZSH_COMPLETION_DIR}/_rustup"
}

install_essential_packages
