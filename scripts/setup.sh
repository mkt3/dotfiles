#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

# variable
REPO_DIR="$(cd "$(dirname "$0")/.."; pwd)"
CONFIGS_DIR="${REPO_DIR}/files"

. "${CONFIGS_DIR}/zsh/zshenv.zsh"

if [ "$GUI_ENV" = "y" ]; then
    UI="GUI"
elif [ "$GUI_ENV" = "n" ]; then
    UI="CUI"
else
    echo "Invalid input for GUI_ENV."
    exit 1
fi

if [ "$DEV_ENV" = "y" ]; then
    DEV="dev"
elif [ "$GUI_ENV" = "n" ]; then
    DEV="nodev"
else
    echo "Invalid input for DEV_ENV."
    exit 1
fi

DEV=${2:-"nodev"}

. "${REPO_DIR}/scripts/common.sh"

setup_files="${REPO_DIR}/scripts/**/setup.sh"
for filepath in $setup_files; do
    . "$filepath"
done

### fzf


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
    if [ "$DEV" = "dev" ]; then
        setup_rtx
    fi
    setup_ripgrep
}

setup_post_common() {
    # setup_textlint
    if [ "$DEV" = "dev" ]; then
        setup_nodejs
        setup_python
    fi
    setup_ghq
    setup_navi
    setup_lazygit
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
    fi
}

setup_linux() {
    local distro
    distro=$(awk '{print $1; exit}' /etc/issue)
    title "Setting up ${distro}"

    if [ "$UI" = "cui" ]; then
        sudo systemctl set-default multi-user.target
    elif [ "$UI" = "gui" ]; then
        sudo systemctl set-default graphical.target
    fi

    # distribution
    case $distro in
        Arch)
            setup_pre_common
            setup_linux_ui
            setup_post_common
            ;;
        Ubuntu)
            setup_pre_common
            setup_linux_ui
            setup_post_common
            ;;
        *)
            echo "${distro} is not supported."
            exit 1
    esac
}


setup_mac() {
    title "Setting up mac"
    setup_macos
    setup_wezterm
    setup_pre_common
    setup_karabiner
    setup_yabai_skhd_sketchybar
    setup_aquaskk
    setup_skk
    setup_latex
    setup_post_common
}

execute_setup() {
    case "$OS" in
        Darwin)
            setup_mac
            ;;
        Linux)
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


# main code
execute_setup
