#!/usr/bin/env bash

set -eu

post_setup_skk() {
    info "Creating symlink for zsh"
    local skk_rule_path="${XDG_CONFIG_HOME}/libskk/rules"
    mkdir -p "$skk_rule_path"

    ln -sfn "${CONFIGS_DIR}/skk/StickyShift" "${skk_rule_path}/StickyShift"
}
