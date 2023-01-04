#!/usr/bin/env bash

set -eu

setup_xdg_config() {
    title "Setting up XDG Direcotry"
    mkdir -p "$XDG_CONFIG_HOME"
    mkdir -p "$XDG_CACHE_HOME"
    mkdir -p "$XDG_DATA_HOME"
    mkdir -p "$XDG_STATE_HOME"
    mkdir -p "${HOME}/.local/bin"
    mkdir -p "${HOME}/.local/src"
}
