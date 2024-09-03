#!/usr/bin/env bash


COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_GRAY}=============================================${COLOR_NONE}"
    echo -e "${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}---------------------------------------------${COLOR_NONE}"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

# Paltform Arch
export OS=`uname -s`
export ARCH=`uname -m`
DISTRO="$OS"
if [[ "$DISTRO" == "Linux" ]];then
    DISTRO=$(grep -oP '(?<=^NAME=).+' /etc/os-release | tr -d '"')
fi

# XDG Base directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/completion"

# PATH
if [[ "$DISTRO" == 'NixOS' ]];then
    export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH}"
    export PATH="${HOME}/.nix-profile/bin:/etc/profiles/per-user/${USER}/bin:/run/wrappers/bin:${PATH}"
elif [[ "$DISTRO" == 'Darwin' ]];then
    MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

    if [[ "$ARCH" == 'arm64' ]]; then
        export PATH="/opt/homebrew/bin:${MAC_DEFAULT_PATH}"
    elif [[ "$ARCH" == 'x86_64' ]]; then
        export PATH="/usr/local/bin:${MAC_DEFAULT_PATH}"
    fi
    # nix
    export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH}"
    export PATH="/etc/profiles/per-user/${USER}/bin:${PATH}"
    export NIX_PATH="darwin-config=$HOME/.conifg/nix/flake.nix:/nix/var/nix/profiles/per-user/root/channels"
    export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    export XDG_CONFIG_DIRS=":/run/current-system/sw/etc/xdg:/nix/var/nix/profiles/default/etc/xdg"
    export XDG_DATA_DIRS="/run/current-system/sw/share:/nix/var/nix/profiles/default/share"
    export TERM="$TERM"
    export NIX_USER_PROFILE_DIR="/etc/profiles/per-user/${USER}"
    export NIX_PROFILES="/nix/var/nix/profiles/default /run/current-system/sw"
    # Set up secure multi-user builds: non-root users build through the
    # Nix daemon.
    if [ ! -w /nix/var/nix/db ]; then
        export NIX_REMOTE=daemon
    fi
else # for linux (except NIXOS)
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin"
    export PATH="$LINUX_DEFAULT_PATH"

    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi
export PATH="${HOME}/.local/bin:${PATH}"


# GnuPG
## default value is ~/.gnupg.  If use non-default GnuPG Home directory, need to edit all socket files.
export GNUPGHOME="${HOME}/.gnupg"
