#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

title "Upgrade Nix"

if [ "$DISTRO" != "Ubuntu" ]; then
    info "Skipping Nix self-upgrade on ${DISTRO}; Nix is managed by the system configuration."
    exit 0
fi

if ! command -v nix >/dev/null 2>&1; then
    error "Nix is not installed or is not available in PATH."
fi

if ! command -v sudo >/dev/null 2>&1; then
    error "sudo is required to upgrade the multi-user Nix installation."
fi

current_version="$(nix --version)"
info "Current version: ${current_version}"

# The official Nix installer uses the root profile for multi-user installs.
nix_profile="/nix/var/nix/profiles/default"
sudo -i nix upgrade-nix --profile "$nix_profile"

hash -r
updated_version="$(nix --version)"
success "Nix upgrade complete: ${updated_version}"
