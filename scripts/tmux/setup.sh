#!/usr/bin/env bash

set -eu

setup_tmux() {
    title "Setting up tmux"
    local tmux_dir="$CONFIGS_DIR/tmux"

    info "Creating symlink for tmux"
    ln -sfn "$tmux_dir" "${XDG_CONFIG_HOME}/tmux"

    local tpm_git_url="https://github.com/tmux-plugins/tpm.git"
    local tpm_install_dir="${XDG_CONFIG_HOME}/tmux/plugins/tpm"

    if [ -d "$tpm_install_dir" ]; then
        info "Updating tpm repository"
        git -C "$tpm_install_dir" pull
    else
        info "Clonening tpm repository"
        git clone $tpm_git_url "$tpm_install_dir"
    fi

    if [[ "$OS" == "Darwin" ]] && ! infocmp tmux-256color >/dev/null 2>&1; then
        tmpfile=$(mktemp /tmp/tempfile.XXXXXX)
        trap 'rm -f "$tmpfile"' EXIT
        if [[ "$ARCH" == 'arm64' ]]; then
            /opt/homebrew/opt/ncurses/bin/infocmp tmux-256color > "$tmpfile"
        elif [[ "$ARCH" == 'x86_64' ]]; then
            /usr/local/opt/ncurses/bin/infocmp tmux-256color > "$tmpfile"
        fi
        tic -xe tmux-256color "$tmpfile"
    fi

    if [[ "$OS" == "Linux" ]] && ! (type tmux > /dev/null 2>&1); then
        "${tmux_dir}/build_tmux.sh"
    fi
}
