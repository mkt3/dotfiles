#!/usr/bin/env bash

INSTALL_DIR="${INSTALL_DIR:-$HOME/workspace/ghq/github.com/mkt3/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/mkt3/dotfiles "$INSTALL_DIR"
fi

cd "$INSTALL_DIR" && make
