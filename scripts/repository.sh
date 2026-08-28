#!/usr/bin/env bash

if [ -z "${REPO_DIR:-}" ]; then
    repository_script_dir="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    REPO_DIR="$(CDPATH='' cd -- "${repository_script_dir}/.." && pwd)"
fi
