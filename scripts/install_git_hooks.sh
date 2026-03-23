#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

repo_dir="${TARGET_REPO_DIR:-$REPO_DIR}"
config_file="${repo_dir}/.pre-commit-config.yaml"

title "Install/Update git hooks"

if ! git -C "$repo_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    info "Skip git hook install: ${repo_dir} is not a git repository."
    exit 0
fi

if [ ! -f "$config_file" ]; then
    info "Skip git hook install: ${config_file} was not found."
    exit 0
fi

if ! command -v prek >/dev/null 2>&1; then
    warning "Skip git hook install: prek is not available in PATH."
    exit 0
fi

(
    cd "$repo_dir"
    prek install
)

success "Git hooks are up to date."
