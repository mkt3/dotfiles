#!/usr/bin/env bash

set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/workspace/ghq/github.com/mkt3/dotfiles}"

CLONED=false

ensure_nix() {
    if command -v nix >/dev/null 2>&1; then
        return 0
    fi

    curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
}

load_nix() {
    local profile_script=""

    for profile_script in \
        "${HOME}/.nix-profile/etc/profile.d/nix.sh" \
        "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" \
        "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
    do
        if [ -r "$profile_script" ]; then
            # shellcheck source=/dev/null
            . "$profile_script"
            break
        fi
    done

    command -v nix >/dev/null 2>&1 || {
        echo "nix is installed but not available in this shell. Start a new shell and rerun install.sh."
        exit 1
    }
}

ensure_nix
load_nix

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning dotfiles..."
    nix shell nixpkgs#git --command git clone https://github.com/mkt3/dotfiles "$INSTALL_DIR"
    CLONED=true
fi

# shellcheck source=/dev/null
. "${INSTALL_DIR}/nix/home-manager/programs/zsh/env.sh"

[ "$CLONED" = true ] && REPO_DIR="$INSTALL_DIR" /usr/bin/env bash "${INSTALL_DIR}/scripts/install_essential_packages.sh"

nix shell nixpkgs#gnumake --command make -C "$INSTALL_DIR"
