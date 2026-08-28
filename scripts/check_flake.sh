#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
HOSTNAME_ENV="${HOSTNAME_ENV:-check-host}"
DEV_ENV="${DEV_ENV:-y}"
GUI_ENV="${GUI_ENV:-y}"

tmp_dir="$(CDPATH='' cd -- "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp_dir"' EXIT

export XDG_CONFIG_HOME="${tmp_dir}/config"
export XDG_CACHE_HOME="${tmp_dir}/cache"

# shellcheck source=/dev/null
. "${script_dir}/common.sh"
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/nix/setup.sh"

export CONFIGS_DIR="${REPO_DIR}/nix"

DISTRO="${CHECK_DISTRO:-$DISTRO}"

if [ "$DISTRO" = "NixOS" ] && { [ "${USE_SYNTHETIC_NIXOS_HARDWARE:-n}" = "y" ] || [ ! -f /etc/nixos/hardware-configuration.nix ]; }; then
    hardware_config="${tmp_dir}/hardware-configuration.nix"
    write_synthetic_nixos_hardware_config "$hardware_config"
    export NIXOS_HARDWARE_CONFIG_OVERRIDE="$hardware_config"
fi

pre_setup_nix
flake_ref="path:${XDG_CONFIG_HOME}/nix"
if [ "${SKIP_FLAKE_SHOW:-n}" != "y" ]; then
    "${NIX_CMD[@]}" flake show "$flake_ref"
fi

case "$DISTRO" in
    NixOS)
        configuration_attr="nixosConfigurations.\"${HOSTNAME_ENV}\".config.system.build.toplevel"
        ;;
    Darwin)
        configuration_attr="darwinConfigurations.\"${HOSTNAME_ENV}\".system"
        ;;
    *)
        configuration_attr="homeConfigurations.\"${USER}\".activationPackage"
        ;;
esac

if [ -n "${BUILD_OUTPUT_FILE:-}" ]; then
    "${NIX_CMD[@]}" build \
        "${flake_ref}#${configuration_attr}" \
        --no-link \
        --print-out-paths > "$BUILD_OUTPUT_FILE"
else
    "${NIX_CMD[@]}" eval --raw "${flake_ref}#${configuration_attr}.drvPath"
fi
