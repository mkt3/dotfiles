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

    if ! infocmp tmux-256color >/dev/null 2>&1; then
        brew install ncurses
        tmpfile=$(mktemp /tmp/tempfile.XXXXXX)
        trap 'rm -f "$tmpfile"' EXIT
        infocmp tmux-256color > "$tmpfile"
        tic -xe tmux-256color "$tmpfile"
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
    if ! (type nix > /dev/null 2>&1); then
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # elif [[ "$OS" == "Linux" ]]; then
    #    sudo -i nix upgrade-nix || true
    fi
    # local CONFIG_FILE="/etc/nix/nix.conf"
    # local FEATURES="experimental-features = nix-command flakes"

    # [ -d "$(dirname "$CONFIG_FILE")" ] || sudo mkdir -p "$(dirname "$CONFIG_FILE")"

    # if ! grep -Fxq "$FEATURES" "$CONFIG_FILE" 2>/dev/null; then
    #    echo "$FEATURES" | sudo tee -a "$CONFIG_FILE" > /dev/null
    #fi

}

install_essential_packages
