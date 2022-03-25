#!/usr/bin/env bash

set -eu

setup_ghq() {
    title "Setting up ghq"

    info "Installing ghq"
    go install github.com/x-motemen/ghq@latest
}
