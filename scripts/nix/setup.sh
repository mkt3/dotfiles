#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_dir="${CONFIGS_DIR}/nix"
    local nix_main_flake_dir
    local home_manager_dir
    if [ "$OS" = "Darwin" ]; then
        nix_main_flake_dir="${XDG_CONFIG_HOME}/nix-darwin"
        home_manager_dir="${nix_main_flake_dir}/home-manager"
    elif [ "$OS" = "Linux" ]; then
        nix_main_flake_dir="${XDG_CONFIG_HOME}/home-manager"
        home_manager_dir="$nix_main_flake_dir"
    fi

    local nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')


    mkdir -p "${XDG_CONFIG_HOME}/nix"
    ln -sfn "${nix_dir}/nix.conf" "${XDG_CONFIG_HOME}/nix/"

    mkdir -p "$nix_main_flake_dir"
    mkdir -p "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/overlays" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/programs" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/services" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/home.nix" "$home_manager_dir"

    nix_main_flake="${nix_main_flake_dir}/flake.nix"
    if [ "$OS" = "Darwin" ]; then
        local host_name=$(hostname | sed "s/\.local//g")
        cp -rf "${nix_dir}/nix-darwin/modules" "$nix_main_flake_dir"
        cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"

        cp -rf "${nix_dir}/nix-darwin/flake_template.nix" "$nix_main_flake"

        /usr/bin/sed -i "" "s|__SYSTEM__|${nix_platform}|g" "$nix_main_flake"
        /usr/bin/sed -i "" "s|__HOSTNAME__|${host_name}|g" "$nix_main_flake"
        /usr/bin/sed -i "" "s|__USERNAME__|${USER}|g" "$nix_main_flake"
    elif [ "$OS" = "Linux" ]; then
        cp -rf "${nix_dir}/nix-linux/flake_template.nix" "$nix_main_flake"

        sed -i "s|__SYSTEM__|${nix_platform}|g" "$nix_main_flake"
        sed -i "s|__USERNAME__|${USER}|g" "$nix_main_flake"

        if [ "$GUI_ENV" = "y" ]; then
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-pgtk.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        else
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git-nox.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        fi
    fi
}
