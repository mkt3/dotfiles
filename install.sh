#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/workspace/ghq/github.com/mkt3/dotfiles}"


if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/mkt3/dotfiles "$INSTALL_DIR"
fi

. "${INSTALL_DIR}/files/nix/home-manager/programs/zsh/path.zsh"

[ ! -d "$INSTALL_DIR" ] && REPO_DIR="$INSTALL_DIR" /usr/bin/env bash "${INSTALL_DIR}/scripts/install_essential_packages.sh"

make -C "$INSTALL_DIR"
