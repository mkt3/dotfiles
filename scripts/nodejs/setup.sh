#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

setup_nodejs() {
    title "Setting up nodejs"

    info "Installing nodejs"
    "${CARGO_HOME}/bin/rtx" install nodejs@18
    "${CARGO_HOME}/bin/rtx" global nodejs@18

    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"
}
