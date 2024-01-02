#!/usr/bin/env bash

set -eu

post_setup_ghq() {
    title "Post setting up ghq"

    git config --global ghq.root "${HOME}/workspace/ghq"
}
