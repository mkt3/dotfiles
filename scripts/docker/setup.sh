#!/usr/bin/env bash

set -eu

setup_docker() {
    title "Setting up docker"

    info "Creating symlink for docker"
    ln -sfn "$CONFIGS_DIR/docker" "${XDG_CONFIG_HOME}/docker"

    info "Downloading docker-compose-completion"
    curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose  -o "${ZSH_COMPLETION_DIR}/_docker-compose"

}
