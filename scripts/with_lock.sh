#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
    echo "Usage: with_lock.sh command [args...]" >&2
    exit 2
fi

lock_root="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
lock_dir="${lock_root}/mkt3-dotfiles-${UID:-$(id -u)}.lock"
pid_file="${lock_dir}/pid"

release_lock() {
    if [ -d "$lock_dir" ] && [ "$(cat "$pid_file" 2>/dev/null || true)" = "$$" ]; then
        rm -f "$pid_file"
        rmdir "$lock_dir" 2>/dev/null || true
    fi
}

acquire_lock() {
    local owner_pid=""

    if mkdir "$lock_dir" 2>/dev/null; then
        printf '%s\n' "$$" > "$pid_file"
        return 0
    fi

    owner_pid="$(cat "$pid_file" 2>/dev/null || true)"
    if [ -n "$owner_pid" ] && kill -0 "$owner_pid" 2>/dev/null; then
        echo "Another dotfiles operation is already running (PID ${owner_pid})." >&2
        return 1
    fi
    if [ -z "$owner_pid" ]; then
        echo "Another dotfiles operation lock is being initialized: ${lock_dir}" >&2
        return 1
    fi

    echo "Removing stale dotfiles operation lock." >&2
    rm -f "$pid_file"
    rmdir "$lock_dir" 2>/dev/null || {
        echo "Unable to remove stale lock: ${lock_dir}" >&2
        return 1
    }

    mkdir "$lock_dir"
    printf '%s\n' "$$" > "$pid_file"
}

trap release_lock EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
acquire_lock
"$@"
