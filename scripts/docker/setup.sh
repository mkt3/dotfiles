#!/usr/bin/env bash

set -eu

setup_docker() {
    title "Setting up docker"
    local docker_config_dir="${XDG_CONFIG_HOME}/docker"

    info "Creating symlink for docker"
    mkdir -p "$docker_config_dir"
    ln -sfn "$CONFIGS_DIR/docker/config.json" "$docker_config_dir"
}
