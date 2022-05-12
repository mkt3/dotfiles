#!/usr/bin/env bash

set -eu

setup_lazygit() {
    title "Setting up lazygit"

    info "Installing lazygit"
    go install github.com/jesseduffield/lazygit@latest
}
