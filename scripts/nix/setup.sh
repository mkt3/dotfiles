#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_config_dir="${CONFIGS_DIR}/nix"

    local nix_main_flake_dir="${XDG_CONFIG_HOME}/nix"
    local home_manager_dir="${nix_main_flake_dir}/home-manager"
    local nix_main_template_flake="${nix_main_flake_dir}/flake_template.nix"
    local nix_main_flake="${nix_main_flake_dir}/flake.nix"
    local nix_platform
    local host_name
    local is_gui
    local is_cui

    if [ "$OS" = "Darwin" ]; then
        sed_command="gsed"
        host_name=$(hostname | sed "s/\.local//g")
    elif [ "$OS" = "Linux" ]; then
        sed_command="sed"
        host_name=$(hostnamectl status --static)
    fi

    nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')

    if [ "$GUI_ENV" = "y" ]; then
        is_gui="true"
        is_cui="false"
    else
        is_gui="false"
        is_cui="true"
    fi

    #rm -rf  "${XDG_CONFIG_HOME}/nix" # need flake.lock
    cp -rf "${nix_config_dir}" "${XDG_CONFIG_HOME}"
    mv "$nix_main_template_flake" "$nix_main_flake"
    if [ "$DISTRO" = "NixOS" ]; then
       cp -rf "/etc/nixos/hardware-configuration.nix" "$nix_main_flake_dir/systems/nixos"
    fi

    "$sed_command" -i "s|__SYSTEM__|${nix_platform}|g" "$nix_main_flake"
    "$sed_command" -i "s|__HOSTNAME__|${host_name}|g" "$nix_main_flake"
    "$sed_command" -i "s|__USERNAME__|${USER}|g" "$nix_main_flake"
    "$sed_command" -i "s|__HOMEDIRECTORY__|${HOME}|g" "$nix_main_flake"
    "$sed_command" -i "s|__ISGUI__|${is_gui}|g" "$nix_main_flake"
    "$sed_command" -i "s|__ISCUI__|${is_cui}|g" "$nix_main_flake"

    if [ "$OS" = "Darwin" ]; then
        cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
    elif [ "$OS" = "Linux" ]; then
        if [ "$GUI_ENV" = "y" ]; then
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git-pgtk.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        else
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git-nox.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        fi
    fi
}
