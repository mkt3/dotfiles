#!/usr/bin/env bash

set -eu

post_setup_ghq() {
    info "Setting gpg.root"
    git config --global ghq.root "${HOME}/workspace/ghq"
}
