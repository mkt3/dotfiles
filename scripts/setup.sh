#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

# variable
REPO_DIR="$(cd "$(dirname "$0")/.."; pwd)"
CONFIGS_DIR="${REPO_DIR}/files"

SETUP="TRUE"
. "${CONFIGS_DIR}/zsh/zshenv.zsh"

ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/completion"

UI=$1

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

. "${REPO_DIR}/scripts/common.sh"

setup_files="${REPO_DIR}/scripts/**/setup.sh"
for filepath in $setup_files; do
    . "$filepath"
done

# function
setup_pre_common() {
    setup_xdg_config
    setup_gpg
    setup_zsh
    setup_fzf
    setup_tmux
    setup_git
    setup_emacs
    setup_vim
    setup_docker
    setup_rust
    setup_rtx
    setup_ripgrep
}

setup_post_common() {
    setup_nodejs
    # setup_textlint
    setup_python
    setup_ghq
    setup_navi
    setup_lazygit
}

setup_minimal() {
    title "Setting up minimal"
    setup_xdg_config
    setup_gpg
    setup_zsh
    setup_fzf
    setup_tmux
    setup_git
    setup_vim
    setup_rust
    setup_ripgrep
}

setup_linux_ui() {
    # GUI only
    if [ "$UI" = "gui" ]; then
        setup_font
        setup_xwindow
        setup_sway
        setup_mako
        setup_wezterm
        setup_xremap
        setup_skk
        setup_borg
        setup_zathura
    fi
}

setup_linux() {
    local distro=$(awk '{print $1; exit}' /etc/issue)
    title "Setting up ${distro}"

    # distribution
    case $distro in
        Arch)
            setup_pre_common
            setup_pacman
            setup_linux_ui
            setup_post_common
            ;;
        Ubuntu)
            setup_pre_common
            setup_apt
            setup_linux_ui
            setup_post_common
            ;;
        Raspbian*)
            setup_pre_common
            setup_apt
            setup_linux_ui
            setup_post_common
            ;;
        *)
            setup_minimal
    esac
}


setup_mac() {
    title "Setting up mac"
    setup_macos
    setup_homebrew
    setup_wezterm
    setup_pre_common
    setup_karabiner
    setup_yabai_skhd
    setup_aquaskk
    setup_latex
    setup_post_common
}

execute_setup() {
    case $OS in
        darwin)
            setup_mac
            ;;
        linux)
            setup_linux
            ;;
        *)
            echo "${OS} is not supported."
            exit 1
        ;;
    esac

    echo ""
    success "Setup is complete."
}

check_argument() {
    if [ $# -ne 1 ]; then
        echo "Please enter one argument: 'gui' or 'cui' or 'minimal'."
        exit 1
    fi

    if [ "$UI" != "gui" ] && [ "$UI" != "cui" ]; then
        echo "Invalid argument. Please enter 'gui' or 'cui'."
        exit 1
    fi
}

# main code
check_argument "$@"
execute_setup
