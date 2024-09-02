#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_config_dir="${CONFIGS_DIR}/nix"

    local nix_main_flake_dir="${XDG_CONFIG_HOME}/nix"
    local nix_main_template_flake="${nix_main_flake_dir}/flake_template.nix"
    local nix_main_flake="${nix_main_flake_dir}/flake.nix"
    local nix_platform
    local host_name
    local is_gui

    if [ "$OS" = "Darwin" ]; then
        sed_command="gsed"
        host_name=$(hostname | sed "s/\.local//g")
    elif [ "$OS" = "Linux" ]; then
        sed_command="sed"
        host_name=$(hostnamectl status --static)
    fi

    nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')
    nix_platform=${nix_platform/arm64-darwin/aarch64-darwin}

    is_gui=$([ "$GUI_ENV" = "y" ] && echo "true" || echo "false")

    if [ -f "${XDG_CONFIG_HOME}/nix/flake.lock" ]; then
        cp -rf "${XDG_CONFIG_HOME}/nix/flake.lock" "$nix_config_dir"
    fi
    rm -rf  "${XDG_CONFIG_HOME}/nix"
    cp -rf "$nix_config_dir" "$XDG_CONFIG_HOME"
    mv "$nix_main_template_flake" "$nix_main_flake"
    if [ "$DISTRO" = "NixOS" ]; then
       cp -rf "/etc/nixos/hardware-configuration.nix" "${nix_main_flake_dir}/systems/nixos"
    fi

    "$sed_command" -i "s|__SYSTEM__|${nix_platform}|g" "$nix_main_flake"
    "$sed_command" -i "s|__HOSTNAME__|${host_name}|g" "$nix_main_flake"
    "$sed_command" -i "s|__USERNAME__|${USER}|g" "$nix_main_flake"
    "$sed_command" -i "s|__HOMEDIRECTORY__|${HOME}|g" "$nix_main_flake"
    "$sed_command" -i "s|\"__ISGUI__\"|${is_gui}|g" "$nix_main_flake"
}
