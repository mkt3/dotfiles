#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
tmp_dir="$(CDPATH='' cd -- "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp_dir"' EXIT

export XDG_CONFIG_HOME="${tmp_dir}/config"
export XDG_CACHE_HOME="${tmp_dir}/cache"
export CONFIGS_DIR="${REPO_DIR}/nix"
export HOSTNAME_ENV="cache-nixos-gui"
export DEV_ENV="y"
export GUI_ENV="y"
export NIX_PLATFORM_OVERRIDE="x86_64-linux"
export USER="${USER:-attic-cache-builder}"

export DISTRO="NixOS"
NIX_CMD=(nix)

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/nix/setup.sh"

info "Updating nvfetcher sources for the cache builder"
if command -v nvfetcher > /dev/null 2>&1; then
    nvfetcher_command=(nvfetcher)
else
    nvfetcher_command=("${NIX_CMD[@]}" run github:berberman/nvfetcher --)
fi
"${nvfetcher_command[@]}" \
    -c "${REPO_DIR}/nix/nvfetcher.toml" \
    -o "${REPO_DIR}/nix/_sources"

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

pre_setup_nix
"${NIX_CMD[@]}" flake update --flake "path:${XDG_CONFIG_HOME}/nix"
sync_flake_lock_to_repo "${XDG_CONFIG_HOME}/nix/flake.lock"
