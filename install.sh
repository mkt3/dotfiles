#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/workspace/ghq/github.com/mkt3/dotfiles}"

CLONED=false

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/mkt3/dotfiles "$INSTALL_DIR"
    CLONED=true
fi

. "${INSTALL_DIR}/files/nix/home-manager/programs/zsh/path.zsh"

[ "$CLONED" = true ] && REPO_DIR="$INSTALL_DIR" /usr/bin/env bash "${INSTALL_DIR}/scripts/install_essential_packages.sh"

make -C "$INSTALL_DIR"
