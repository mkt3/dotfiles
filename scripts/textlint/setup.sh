#!/usr/bin/env bash

set -eu

setup_textlint() {
    title "Setting up textlint"

    local textlint_file_dir="${CONFIGS_DIR}/textlint"

    info "Creating symlink for textlint"
    ln -sfn $textlint_file_dir "${XDG_CONFIG_HOME}/textlint"

    info "Creating symlink for textlint.sh"
    ln -sfn "${textlint_file_dir}/textlint.sh" "${HOME}/.local/bin/textlint.sh"

    info "Installing textlint's packages"
    package_list=(textlint textlint-plugin-org traverse textlint-rule-preset-ja-technical-writing textlint-rule-preset-ja-spacing textlint-rule-alex textlint-rule-common-misspellings textlint-rule-ginger textlint-rule-write-good textlint-rule-en-max-word-count)
    for package in ${package_list[@]}; do
        info "$package ..."
        npm install -g $package
    done
}
