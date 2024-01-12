#!/usr/bin/env bash

set -eu

pre_setup_textlint() {
    local textlint_file_dir="${CONFIGS_DIR}/textlint"

    info "Creating symlink for textlint"
    ln -sfn "$textlint_file_dir" "${XDG_CONFIG_HOME}/textlint"

    info "Creating symlink for textlint.sh"
    ln -sfn "${textlint_file_dir}/textlint.sh" "${HOME}/.local/bin/textlint.sh"

}
