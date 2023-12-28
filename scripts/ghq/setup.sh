#!/usr/bin/env bash

set -eu

setup_ghq() {
    title "Setting up ghq"

    git config --global ghq.root "${HOME}/workspace/ghq"
}
