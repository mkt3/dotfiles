#!/usr/bin/env bash

set -eu

setup_skk() {
    title "Setting up skk"

    info "Creating symlink for zsh"
    local skk_rule_path="${XDG_CONFIG/HOME}/libskk/rules"
    mkdir -p $skk_rule_path

    ln -sfn "${CONFIGS_DIR}/skk/StickyShift" "${skk_rule_path}/StickyShift"
}
