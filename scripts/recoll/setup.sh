#!/usr/bin/env bash

set -eu

pre_setup_recoll() {
    info "Creating symlink for recoll"
    mkdir -p "${XDG_CONFIG_HOME}/recoll"
    ln -sfn "$CONFIGS_DIR/recoll/recoll.conf" "${RECOLL_CONFDIR}"
}
