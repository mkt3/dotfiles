#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
HOSTNAME_ENV="${HOSTNAME_ENV:-check-host}"
DEV_ENV="${DEV_ENV:-y}"
GUI_ENV="${GUI_ENV:-y}"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

export XDG_CONFIG_HOME="${tmp_dir}/config"
export XDG_CACHE_HOME="${tmp_dir}/cache"
export CONFIGS_DIR="${REPO_DIR}/nix"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/nix/setup.sh"

pre_setup_nix
nix --extra-experimental-features "nix-command flakes" flake show "path:${XDG_CONFIG_HOME}/nix"
