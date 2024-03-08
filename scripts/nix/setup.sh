#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_dir="${CONFIGS_DIR}/nix"
    local nix_main_flake_dir
    local home_manager_dir
    local host_name
    if [ "$OS" = "Darwin" ]; then
        nix_main_flake_dir="${XDG_CONFIG_HOME}/nix-darwin"
        home_manager_dir="${nix_main_flake_dir}/home-manager"
        nix_main_template_flake="${nix_dir}/nix-darwin/flake_template.nix"
        sed_command="gsed"
        host_name=$(hostname | sed "s/\.local//g")
    elif [ "$OS" = "Linux" ]; then
        nix_main_flake_dir="${XDG_CONFIG_HOME}/home-manager"
        home_manager_dir="$nix_main_flake_dir"
        nix_main_template_flake="${nix_dir}/nix-linux/flake_template.nix"
        sed_command="sed"
        host_name=$(hostnamectl status --static)
    fi

    local nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')

    local is_gui
    local is_cui
    if [ "$GUI_ENV" = "y" ]; then
        is_gui="true"
        is_cui="false"
    else
        is_gui="false"
        is_cui="true"
    fi

    mkdir -p "${XDG_CONFIG_HOME}/nix"
    ln -sfn "${nix_dir}/nix.conf" "${XDG_CONFIG_HOME}/nix/"

    mkdir -p "$nix_main_flake_dir"
    mkdir -p "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/overlays" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/programs" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/services" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/home.nix" "$home_manager_dir"

    nix_main_flake="${nix_main_flake_dir}/flake.nix"

    cp -rf "$nix_main_template_flake" "$nix_main_flake"

    "$sed_command" -i "s|__SYSTEM__|${nix_platform}|g" "$nix_main_flake"
    "$sed_command" -i "s|__HOSTNAME__|${host_name}|g" "$nix_main_flake"
    "$sed_command" -i "s|__USERNAME__|${USER}|g" "$nix_main_flake"
    "$sed_command" -i "s|__ISGUI__|${is_gui}|g" "$nix_main_flake"
    "$sed_command" -i "s|__ISCUI__|${is_cui}|g" "$nix_main_flake"

    if [ "$OS" = "Darwin" ]; then
        cp -rf "${nix_dir}/nix-darwin/modules" "$nix_main_flake_dir"
        cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
    elif [ "$OS" = "Linux" ]; then
        if [ "$GUI_ENV" = "y" ]; then
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-pgtk.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        else
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git-nox.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        fi
    fi
}
