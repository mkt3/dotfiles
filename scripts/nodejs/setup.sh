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
    local npm_command="${XDG_DATA_HOME}/node/bin/npm"

    info "Setting up for npm"
    ln -sfn "${CONFIGS_DIR}/npm" "${XDG_CONFIG_HOME}/npm"

    info "Installing npm's packages"
    local installed_package
    installed_package=$("$npm_command" ls -g 2>/dev/null) || installed_package=""
    local package_list=(bash-language-server vscode-langservers-extracted typescript-language-server typescript)
    for package in "${package_list[@]}"; do
        if echo "$installed_package" | grep -q "$package"; then
            info "$package updating..."
            "$npm_command" update -g "$package"
        else
            info "$package installting..."
            "$npm_command" install -g "$package"
        fi
    done
}
