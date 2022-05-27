#!/usr/bin/env bash

set -eu

setup_docker() {
    title "Setting up docker"
    docker_config_dir="${XDG_CONFIG_HOME}/docker"

    info "Creating symlink for docker"
    mkdir -p $docker_config_dir
    ln -sfn "$CONFIGS_DIR/docker/config.json" $docker_config_dir

    info "Downloading docker-compose-completion"
    curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose  -o "${ZSH_COMPLETION_DIR}/_docker-compose"

}
