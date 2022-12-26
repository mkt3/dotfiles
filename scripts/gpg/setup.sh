#!/usr/bin/env bash

set -eu

setup_gpg() {
    title "Setting up GPG"

    mkdir -p $GNUPGHOME
    chmod 700 $GNUPGHOME
}
