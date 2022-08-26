#!/bin/bash

set -eu

REPO_DIR="$(cd "$(dirname "$0")/.."; pwd)"
CONFIGS_DIR="${REPO_DIR}/files"

SETUP="TRUE"
. "${CONFIGS_DIR}/zsh/.zshenv"

ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/completion"

. "${REPO_DIR}/scripts/common.sh"

setup_files="${REPO_DIR}/scripts/**/setup.sh"
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
    setup_emacs
    setup_vim
    setup_docker
    setup_rust
    setup_ripgrep
}

setup_post_common() {
    setup_nodejs
    # setup_textlint
    setup_python $1
    setup_ghq
    setup_navi
    setup_lazygit
}

setup_arch() {
    title "Setting up Archlinux"
    setup_pre_common
    setup_pacman

    if [ $1 = "gui" ]; then
        setup_font
        setup_i3-wm
        setup_picom
        setup_wezterm
        setup_xremap
        setup_skk
    fi

    setup_post_common arch
}

setup_ubuntu() {
    title "Setting up ubuntu"
    setup_apt $1

    setup_pre_common

    if [ $1 = "gui" ]; then
        setup_font
        setup_gnome
        setup_skk
    fi

    setup_post_common ubuntu
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
    setup_yabai_skhd
    setup_aquaskk
    setup_latex
    setup_post_common mac

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
    setup_ripgrep
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
                if systemctl get-default | grep 'graphical.target' > /dev/null 2>&1; then
                    setup_arch gui
                else
                    setup_arch cui
                fi
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
            *)
                setup_minimal
        esac
        ;;
    minimal)
        setup_minimal
        ;;
esac

success "Done."
