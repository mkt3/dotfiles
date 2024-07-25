#!/usr/bin/env bash

set -eu

post_setup_tmux() {
    if [[ "$OS" == "Darwin" ]] && ! infocmp tmux-256color >/dev/null 2>&1; then
        info "Making tmux-256color"
        tmpfile=$(mktemp /tmp/tempfile.XXXXXX)
        trap 'rm -f "$tmpfile"' EXIT
        infocmp tmux-256color > "$tmpfile"
        tic -xe tmux-256color "$tmpfile"
    fi
}
