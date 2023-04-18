#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

setup_nodejs() {
    title "Setting up nodejs"

    info "Installing nodejs"
    local nodejs_version="nodejs@18.15.0"
    "${CARGO_HOME}/bin/rtx" install "$nodejs_version"
    "${CARGO_HOME}/bin/rtx" global "$nodejs_version"

    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"
}
