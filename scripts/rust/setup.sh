#!/usr/bin/env bash

set -eu

setup_rust() {
    title "Setting up rust"

    info "Linking corgo config"
    mkdir -p "$CARGO_HOME"
    ln -sfn "${CONFIGS_DIR}/rust/cargo/config" "${CARGO_HOME}/config"

    if (type rustup > /dev/null 2>&1); then
        rustup self update
        rustup update
    else
        info "Installing rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

    fi

    info "Linking completion"
    "${CARGO_HOME}/bin/rustup" completions zsh > "${ZSH_COMPLETION_DIR}/_rustup"


    info "Installing common packages"
    package_list=(bat fd-find ripgrep git-delta grex lsd bottom du-dust csview)
    for package in "${package_list[@]}"; do
        info "$package ..."
        "${CARGO_HOME}/bin/rustup" run stable cargo install "$package"
    done

    info "Installing rust-analyzer"
    curl -sL https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | zcat > ~/.local/bin/rust-analyzer

    chmod +x ~/.local/bin/rust-analyzer

    "${CARGO_HOME}/bin/rustup" run stable cargo install cargo-edit
}
