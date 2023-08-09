#!/usr/bin/env bash

set -eu

setup_emacs() {
    title "Setting up emacs"
    local emacs_file_dir="$CONFIGS_DIR/emacs"
    local skk_record_file="${XDG_CONFIG_HOME}/emacs/ddskk.d/skk-record"

    mkdir -p "${XDG_CONFIG_HOME}/emacs/ddskk.d"
    info "Creating symlink for emacs"
    ln -sfn "${emacs_file_dir}/README.org" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/early-init.el" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/init.el" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/templates" "${XDG_CONFIG_HOME}/emacs/"
    ln -sfn "${emacs_file_dir}/ddskk.d/init.el" "${XDG_CONFIG_HOME}/emacs/ddskk.d/"

    if [ ! -e "$skk_record_file" ]; then
        touch "$skk_record_file"
    fi

    if [ "$UI" = "gui" ]; then
        mkdir -p "${XDG_CONFIG_HOME}/msmtp"
        ln -sfn "${HOME}/Nextcloud/personal_config/emacs_mail/msmtprc" "${XDG_CONFIG_HOME}/msmtp/config"
    fi
    if [ "$OS" = "Darwin" ]; then
        ln -sfn /usr/local/opt/emacs-plus@29/Emacs.app /Applications

        go install gitlab.com/shackra/goimapnotify@latest
    fi

    ## for org-insert-link for nov
    local emacs_lisp_path
    local ol_path
    local sed_command
    if [ "$OS" = "Darwin" ]; then
        emacs_lisp_path="/usr/local/Cellar/emacs-plus@29"
        sed_command="gsed"
    else
        emacs_lisp_path="/usr/local/share/emacs"
        sed_command="sed"
    fi

    ol_path=$(find $emacs_lisp_path -type f -name "ol.el")

    if [ -n "$ol_path" ]; then
        "$sed_command" -i 's/file\\\\|docview/file\\\\|nov\\\\|docview/g' "$ol_path"
    fi
}
