#!/bin/bash

set -eu

CURRENT_DIR=$(cd $(dirname $0); pwd)
CONFIGS_DIR="${CURRENT_DIR}/files"

SETUP="TRUE"
. ./files/zsh/.zshenv

ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/completion"

. ./scripts/common.sh

setup_files="./scripts/**/setup.sh"
for filepath in $setup_files; do
    . $filepath
done

setup_pre_common() {
    setup_xdg_config
    setup_zsh
    setup_term
    setup_fzf
    setup_tmux
    setup_git
    setup_tig
    setup_emacs
    setup_vim
    setup_docker
    setup_rust
}

setup_post_common() {
    setup_nodejs
    setup_textlint
    setup_python
}

setup_arch() {
    setup_pre_common
    setup_post_common
}

setup_ubuntu() {
    title "Setting up ubuntu"
    setup_pre_common

    setup_apt $1
    if [ $1 = "gui" ]; then
        setup_font
        setup_gnome
        setup_skk
    fi

    setup_post_common
}

setup_photon() {
    setup_minimal
}

setup_mac() {
    title "Setting up mac"
    setup_macos
    setup_homebrew
    setup_pre_common
    setup_karabiner
    setup_aquaskk
    setup_post_common

}

setup_minimal() {
    title "Setting up minimal"
    setup_xdg_config
    setup_term
    setup_fzf
    setup_zsh
    setup_tmux
    setup_git
    setup_vim
    setup_docker
}

os=$(uname -s | tr '[A-Z]' '[a-z]')

if [ $# -eq 1 ] && [ $1 = "minimal" ]; then
    os="minimal"
fi

case $os in
    darwin)
        setup_mac
        ;;
    linux)
        dist=$(cat /etc/issue | tr '[A-Z]' '[a-z]')
        case $dist in
            arch*)
                setup_arch
                ;;
            ubuntu*)
                if systemctl get-default | grep 'graphical.target' > /dev/null 2>&1; then
                    setup_ubuntu gui
                else
                    setup_ubuntu cui
                fi
                ;;
            *photon*)
                setup_photon
                ;;
        esac
        ;;
    minimal)
        setup_minimal
        ;;
esac

success "Done."