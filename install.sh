#!/usr/bin/env sh

set -eu

INSTALL_DIR="${INSTALL_DIR:-$HOME/workspace/ghq/github.com/mkt3/dotfiles}"
REPO_URL="https://github.com/mkt3/dotfiles"

CLONED=false

canonical_repo_url() {
    url="${1%/}"
    url="${url%.git}"

    case "$url" in
        git@github.com:*)
            url="https://github.com/${url#git@github.com:}"
            ;;
        ssh://git@github.com/*)
            url="https://github.com/${url#ssh://git@github.com/}"
            ;;
    esac

    printf '%s\n' "$url"
}

ensure_nix() {
    if command -v nix >/dev/null 2>&1; then
        return 0
    fi

    curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
}

load_nix() {
    profile_script=""

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

if [ ! -e "$INSTALL_DIR" ]; then
    echo "Cloning dotfiles..."
    nix shell nixpkgs#git --command git clone "$REPO_URL" "$INSTALL_DIR"
    CLONED=true
elif [ ! -d "$INSTALL_DIR/.git" ]; then
    echo "install.sh expected $INSTALL_DIR to be a git repository, but it is not."
    exit 1
else
    origin_url="$(git -C "$INSTALL_DIR" remote get-url origin 2>/dev/null || true)"

    if [ "$(canonical_repo_url "$origin_url")" != "$(canonical_repo_url "$REPO_URL")" ]; then
        echo "install.sh expected $INSTALL_DIR to point to $REPO_URL, but found ${origin_url:-no origin remote}."
        exit 1
    fi
fi

# shellcheck source=/dev/null
. "${INSTALL_DIR}/nix/home-manager/programs/zsh/env.sh"

[ "$CLONED" = true ] && REPO_DIR="$INSTALL_DIR" /usr/bin/env bash "${INSTALL_DIR}/scripts/install_essential_packages.sh"

nix shell nixpkgs#gnumake --command make -C "$INSTALL_DIR"
