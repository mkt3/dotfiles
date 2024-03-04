#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_dir="${CONFIGS_DIR}/nix"
    local home_manager_dir="${XDG_CONFIG_HOME}/home-manager"

    mkdir -p "${XDG_CONFIG_HOME}/nix"
    ln -sfn "${nix_dir}/nix.conf" "${XDG_CONFIG_HOME}/nix/"

    mkdir -p "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/overlays" "$home_manager_dir"
    cp -rf "${nix_dir}/home-manager/programs" "$home_manager_dir"

    if [ "$OS" = "Darwin" ]; then
        cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
    elif [ "$OS" = "Linux" ]; then
        if [ "$GUI_ENV" = "y" ]; then
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-pgtk.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        else
            cp -rf "${home_manager_dir}/overlays/patched-emacs/emacs-git-nox.nix" "${home_manager_dir}/overlays/patched-emacs/default.nix"
        fi
    fi

    local nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')

    cat << EOF > "${home_manager_dir}/flake.nix"
{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      pkgs = import nixpkgs { system = "$nix_platform"; config.allowUnfree = true; };
    in {
      homeConfigurations."$USER" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
           ({ config, pkgs, ... }: { nixpkgs.overlays = [ emacs-overlay.overlays.emacs (import ./overlays/patched-emacs)]; })
           ./home.nix
        ];
      };
    };
}
EOF
}
