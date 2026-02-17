#!/usr/bin/env bash

set -euo pipefail

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

    if ! command -v brew > /dev/null 2>&1; then
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
    if command -v nix > /dev/null 2>&1; then
        return 0
    fi

    curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
}

install_essential_packages
