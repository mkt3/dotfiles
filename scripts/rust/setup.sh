#!/usr/bin/env bash

set -eu

setup_rust() {
    title "Setting up rust"

    info "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

    info "Linking completion"
    "${CARGO_HOME}/bin/rustup" completions zsh > "${ZSH_COMPLETION_DIR}/_rustup"


    info "Installing common packages"
    package_list=(bat fd-find ripgrep git-delta grex lsd bottom du-dust csview)
    for package in ${package_list[@]}; do
        info "$package ..."
        "${CARGO_HOME}/bin/rustup" run stable cargo install $package
    done
}
