#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"
env_file="${ENV_FILE:-${repo_dir}/results/env_settings}"

HOSTNAME_ENV=""
DEV_ENV=""
GUI_ENV=""
seen_hostname=false
seen_dev=false
seen_gui=false

fail() {
    printf 'Invalid environment settings in %s: %s\n' "$env_file" "$1" >&2
    return 1
}

if [[ ! -f "$env_file" ]]; then
    fail "file not found"
fi
chmod 600 "$env_file"

while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
        ""|'#'*) continue ;;
        HOSTNAME_ENV=*)
            [[ "$seen_hostname" == false ]] || fail "HOSTNAME_ENV is duplicated"
            HOSTNAME_ENV="${line#HOSTNAME_ENV=}"
            seen_hostname=true
            ;;
        DEV_ENV=*)
            [[ "$seen_dev" == false ]] || fail "DEV_ENV is duplicated"
            DEV_ENV="${line#DEV_ENV=}"
            seen_dev=true
            ;;
        GUI_ENV=*)
            [[ "$seen_gui" == false ]] || fail "GUI_ENV is duplicated"
            GUI_ENV="${line#GUI_ENV=}"
            seen_gui=true
            ;;
        *) fail "unknown or malformed entry: ${line}" ;;
    esac
done < "$env_file"

[[ "$seen_hostname" == true ]] || fail "HOSTNAME_ENV is missing"
[[ "$seen_dev" == true ]] || fail "DEV_ENV is missing"
[[ "$seen_gui" == true ]] || fail "GUI_ENV is missing"
[[ "$HOSTNAME_ENV" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || fail "HOSTNAME_ENV contains unsupported characters"
[[ "$DEV_ENV" == y || "$DEV_ENV" == n ]] || fail "DEV_ENV must be y or n"
[[ "$GUI_ENV" == y || "$GUI_ENV" == n ]] || fail "GUI_ENV must be y or n"

export HOSTNAME_ENV DEV_ENV GUI_ENV
