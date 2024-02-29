#!/usr/bin/env bash

set -eu

pre_setup_nix() {
    info "Creating symlink for nix"
    local nix_dir="${CONFIGS_DIR}/nix"
    local home_manager_dir="${XDG_CONFIG_HOME}/home-manager"

    mkdir -p "${XDG_CONFIG_HOME}/nix"
    ln -sfn "${nix_dir}/nix.conf" "${XDG_CONFIG_HOME}/nix/"

    mkdir -p "$home_manager_dir"

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
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      pkgs = import nixpkgs { system = "$nix_platform"; config.allowUnfree = true; };
    in {
      homeConfigurations."$USER" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
EOF
}
