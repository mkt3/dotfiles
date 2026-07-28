#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
HOSTNAME_ENV="${HOSTNAME_ENV:-check-host}"
DEV_ENV="${DEV_ENV:-y}"
GUI_ENV="${GUI_ENV:-y}"

existing_nix_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/nix"
tmp_dir="$(CDPATH='' cd -- "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp_dir"' EXIT

export XDG_CONFIG_HOME="${tmp_dir}/config"
export XDG_CACHE_HOME="${tmp_dir}/cache"
export CONFIGS_DIR="${REPO_DIR}/nix"

if [ -f "${existing_nix_dir}/flake.lock" ]; then
    mkdir -p "${XDG_CONFIG_HOME}/nix"
    cp -f "${existing_nix_dir}/flake.lock" "${XDG_CONFIG_HOME}/nix/flake.lock"
fi

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
"${NIX_CMD[@]}" flake show "$flake_ref"

case "$DISTRO" in
    NixOS)
        configuration_attr="nixosConfigurations.\"${HOSTNAME_ENV}\".config.system.build.toplevel.drvPath"
        ;;
    Darwin)
        configuration_attr="darwinConfigurations.\"${HOSTNAME_ENV}\".system.drvPath"
        ;;
    *)
        configuration_attr="homeConfigurations.\"${USER}\".activationPackage.drvPath"
        ;;
esac

"${NIX_CMD[@]}" eval --raw "${flake_ref}#${configuration_attr}"
