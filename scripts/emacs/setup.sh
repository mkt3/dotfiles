#!/usr/bin/env bash

set -eu

pre_setup_emacs() {
    info "Creating symlink for emacs"
    local emacs_file_dir="$CONFIGS_DIR/emacs"
    local skk_record_file="${XDG_CONFIG_HOME}/emacs/ddskk.d/skk-record"

    mkdir -p "${XDG_CONFIG_HOME}/emacs/eshell"
    mkdir -p "${XDG_CONFIG_HOME}/emacs/ddskk.d"

    ln -sfn "${emacs_file_dir}/README.org" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/early-init.el" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/init.el" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/templates" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/eshell/alias" "${XDG_CONFIG_HOME}/emacs/eshell/"
    ln -sfn "${emacs_file_dir}/ddskk.d/init.el" "${XDG_CONFIG_HOME}/emacs/ddskk.d/"
    ln -sfn "${emacs_file_dir}/build_emacs.sh" "${HOME}/.local/bin/"

    if [ ! -e "$skk_record_file" ]; then
        touch "$skk_record_file"
    fi

    if [ "$GUI_ENV" = "y" ]; then
        mkdir -p "${XDG_CONFIG_HOME}/msmtp"
        ln -sfn "${HOME}/Nextcloud/personal_config/enchant/dict/en_US.dic" "${XDG_CONFIG_HOME}/enchant"
    fi
    if [ "$OS" = "Darwin" ]; then
        ln -sfn /usr/bin/open "${HOME}/.local/bin/xdg-open"
    fi
}
