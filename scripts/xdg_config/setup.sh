#!/usr/bin/env bash

set -eu

pre_setup_xdg_config() {
    info "Making xdg directories..."

    mkdir -p "$XDG_CONFIG_HOME"
    mkdir -p "$XDG_CACHE_HOME"
    mkdir -p "$XDG_DATA_HOME"
    mkdir -p "$XDG_STATE_HOME"
    mkdir -p "${HOME}/.local/bin"
    mkdir -p "${HOME}/.local/src"
    mkdir -p "${HOME}/.ssh" && chmod 700 "${HOME}/.ssh"
}
