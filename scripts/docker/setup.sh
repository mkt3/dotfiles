#!/usr/bin/env bash

set -eu

pre_setup_docker() {
    local docker_config_dir="${XDG_CONFIG_HOME}/docker"

    info "Creating symlink for docker"
    mkdir -p "$docker_config_dir"
    ln -sfn "$CONFIGS_DIR/docker/config.json" "$docker_config_dir"
}
