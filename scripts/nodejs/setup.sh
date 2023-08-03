#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

setup_nodejs() {
    title "Setting up nodejs"

    info "Installing nodejs"
    local nodejs_version="node@20.3.0"
    "${CARGO_HOME}/bin/rtx" install "$nodejs_version"
    "${CARGO_HOME}/bin/rtx" use -g "$nodejs_version"
    ln -sfn "${XDG_DATA_HOME}/rtx/installs/node/latest" "${XDG_DATA_HOME}/node"

    info "Creating symlink for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"

    info "Installing npm's packages"
    local installed_package
    installed_package=$(npm ls --location=global)
    local package_list=(bash-language-server vscode-langservers-extracted typescript-language-server typescript)
    for package in "${package_list[@]}"; do
        if echo "$installed_package" | grep -q "$package"; then
            info "$package updating..."
            "${XDG_DATA_HOME}/node/bin/npm" update --location=global "$package"
        else
            info "$package installting..."
            "${XDG_DATA_HOME}/node/bin/npm" install --location=global "$package"
        fi
    done
}
