#!/usr/bin/env bash

set -eu

setup_textlint() {
    title "Setting up textlint"

    local textlint_file_dir="${CONFIGS_DIR}/textlint"

    info "Creating symlink for textlint"
    ln -sfn "$textlint_file_dir" "${XDG_CONFIG_HOME}/textlint"

    info "Creating symlink for textlint.sh"
    ln -sfn "${textlint_file_dir}/textlint.sh" "${HOME}/.local/bin/textlint.sh"

    info "Installing textlint's packages"
    local installed_package=$(npm ls --location=global)
    local package_list=(textlint textlint-plugin-org traverse textlint-rule-preset-ja-technical-writing textlint-rule-preset-ja-spacing textlint-rule-alex textlint-rule-common-misspellings textlint-rule-ginger textlint-rule-write-good)
    for package in "${package_list[@]}"; do
        if echo "$installed_package" | grep -q "$package"; then
            info "$package updating..."
            npm update --location=global "$package"
        else
            info "$package installting..."
            npm install --location=global "$package"
        fi
    done
}
