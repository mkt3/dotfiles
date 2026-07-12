#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
HOSTNAME_ENV="${HOSTNAME_ENV:-check-host}"
DEV_ENV="${DEV_ENV:-y}"
GUI_ENV="${GUI_ENV:-y}"

tmp_dir="$(CDPATH='' cd -- "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp_dir"' EXIT

export XDG_CONFIG_HOME="${tmp_dir}/config"
export XDG_CACHE_HOME="${tmp_dir}/cache"
export CONFIGS_DIR="${REPO_DIR}/nix"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/nix/setup.sh"

DISTRO="${CHECK_DISTRO:-$DISTRO}"

if [ "$DISTRO" = "NixOS" ] && [ ! -f /etc/nixos/hardware-configuration.nix ]; then
    hardware_config="${tmp_dir}/hardware-configuration.nix"
    printf '%s\n' \
        '{ ... }:' \
        '{' \
        '  fileSystems."/" = {' \
        '    device = "/dev/disk/by-label/nixos";' \
        '    fsType = "ext4";' \
        '  };' \
        '}' > "$hardware_config"
    export NIXOS_HARDWARE_CONFIG_OVERRIDE="$hardware_config"
fi

pre_setup_nix
flake_ref="path:${XDG_CONFIG_HOME}/nix"
nix --extra-experimental-features "nix-command flakes" flake show "$flake_ref"

case "$DISTRO" in
    NixOS)
        nix --extra-experimental-features "nix-command flakes" eval --raw \
            "${flake_ref}#nixosConfigurations.\"${HOSTNAME_ENV}\".config.system.build.toplevel.drvPath"
        ;;
    Darwin)
        nix --extra-experimental-features "nix-command flakes" eval --raw \
            "${flake_ref}#darwinConfigurations.\"${HOSTNAME_ENV}\".system.drvPath"
        ;;
    *)
        nix --extra-experimental-features "nix-command flakes" eval --raw \
            "${flake_ref}#homeConfigurations.\"${USER}\".activationPackage.drvPath"
        ;;
esac
