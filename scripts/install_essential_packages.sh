#!/usr/bin/env bash

set -eu

# variable
CONFIGS_DIR="${REPO_DIR}/files"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${CONFIGS_DIR}/zsh/zshenv.zsh"


install_essential_packages() {
    title "Install/Update essential packages"

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

    install_nix

    ## rust for cargo
    install_rust
}

install_macos() {
    if [ ! -e "/Library/Developer/CommandLineTools/" ]; then
        xcode-select --install
    fi

    if ! (type brew > /dev/null 2>&1); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install bash jq yj gnu-sed
    else
        brew update
    fi
}

install_linux() {
    local distro
    distro=$(awk '{print $1; exit}' /etc/issue)

    # distribution
    case $distro in
        Arch)
            sudo pacman -S --needed --noconfirm git jq wget curl xz base-devel pacman-contrib
            if ! (type yay > /dev/null 2>&1); then
                local yay_repo_dir="${HOME}/.local/src/yay"
                git clone https://aur.archlinux.org/yay.git "$yay_repo_dir" && cd "$yay_repo_dir" && makepkg -si
            fi
            ;;
        Ubuntu)
            sudo apt-get -y install git curl xz-utils jq wget make libssl-dev build-essential
            ;;
        *)
            echo "${distro} is not supported."
            exit 1
    esac

    if ! (type yj > /dev/null 2>&1); then
        local yj_path="${HOME}/.local/bin/yj"
        wget https://github.com/sclevine/yj/releases/latest/download/yj-linux-amd64 -O "$yj_path"
        chmod +x "$yj_path"
    fi
}

install_nix() {
    if ! (type nix > /dev/null 2>&1); then
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    else
        if [[ "$OS" == "Linux" ]]; then
            sudo -i nix upgrade-nix
        fi
    fi
}

install_rust() {
    mkdir -p "$CARGO_HOME"
    ln -sfn "${REPO_DIR}/files/rust/cargo/config" "${CARGO_HOME}/config"

    if (type rustup > /dev/null 2>&1); then
        rustup self update
        rustup update
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    fi

    mkdir -p "$ZSH_COMPLETION_DIR"
    "${CARGO_HOME}/bin/rustup" completions zsh > "${ZSH_COMPLETION_DIR}/_rustup"
}

install_essential_packages
