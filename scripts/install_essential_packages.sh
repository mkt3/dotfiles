#!/usr/bin/env bash

set -eu

# variable
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

install_essential_packages() {
    title "Install/Update essential packages"

    mkdir -p "$XDG_CONFIG_HOME"

    mkdir -p "$GNUPGHOME" && chmod 700 "$GNUPGHOME"
    mkdir -p "${HOME}/.local/bin"

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

    if [[ "$DISTRO" != "NixOS" ]]; then
       install_nix
    fi
}

install_macos() {
    if [ ! -e "/Library/Developer/CommandLineTools/" ]; then
        xcode-select --install
    fi

    if ! (type brew > /dev/null 2>&1); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_linux() {
    case "$DISTRO" in
        "Arch Linux")
            sudo pacman -S --needed --noconfirm curl pacman-contrib
            ;;
        "Ubuntu")
            sudo apt install -y make
            ;;
        *)
            ;;
    esac
}

install_nix() {
    if (type nix > /dev/null 2>&1); then
        exit 0
    fi

    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

    if [ "${OS}" = "Linux" ] && [ ! -f /etc/nix/nix.conf ]; then
        sudo mkdir -p /etc/nix
        echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf >/dev/null
    fi
}

install_essential_packages
