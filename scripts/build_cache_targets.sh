#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
tmp_dir="$(CDPATH='' cd -- "$(mktemp -d)" && pwd -P)"
output_file="${CACHE_TARGETS_OUTPUT:-${tmp_dir}/store-paths}"
trap 'rm -rf "$tmp_dir"' EXIT

: > "$output_file"

build_target() {
    local target="$1"
    local distro="$2"
    local dev="$3"
    local gui="$4"
    local target_output="${tmp_dir}/${target}"
    local store_path=""

    printf 'Building cache target %s\n' "$target" >&2
    env \
        REPO_DIR="$REPO_DIR" \
        HOSTNAME_ENV="$target" \
        DEV_ENV="$dev" \
        GUI_ENV="$gui" \
        CHECK_DISTRO="$distro" \
        NIX_PLATFORM_OVERRIDE="x86_64-linux" \
        USE_SYNTHETIC_NIXOS_HARDWARE="y" \
        SKIP_FLAKE_SHOW="y" \
        BUILD_OUTPUT_FILE="$target_output" \
        /usr/bin/env bash "${REPO_DIR}/scripts/check_flake.sh"

    store_path="$(<"$target_output")"
    if [ -z "$store_path" ]; then
        printf 'Cache target %s did not produce a store path\n' "$target" >&2
        return 1
    fi

    printf '%s\n' "$store_path" >> "$output_file"
    printf 'Built cache target %s: %s\n' "$target" "$store_path" >&2
}

build_target "cache-nixos-gui" "NixOS" "y" "y"

cat "$output_file"
