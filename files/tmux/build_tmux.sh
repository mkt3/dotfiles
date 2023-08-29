#!/usr/bin/env bash

# constnt value
OS=$(uname -s)
UI=$1
TMUX_REPO="https://github.com/tmux/tmux.git"
TMUX_REPO_PATH="${HOME}/.local/src/tmux"
BRANCH="master"

# Install library
case "$OS" in
    Darwin)
        echo "Use homebrew in ${OS}"
        exit 1
        ;;
    Linux)
        DISTRO=$(awk '{print $1; exit}' /etc/issue)

        case "$DISTRO" in
            Arch)
                echo "Use pacman in ${DISTRO}"
                exit 1
                ;;
            Ubuntu)
                DEPENDENCIES="automake pkg-config libevent-dev libncurses-dev"

                sudo apt install -y $DEPENDENCIES
                ;;
            *)
                echo "${DISTRO} is not supported distribution."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "${OS} is not supported OS."
        exit 1
        ;;
esac

# clone
if [ -d "$TMUX_REPO_PATH" ]; then
    cd "$TMUX_REPO_PATH" || exit
    make distclean
    git switch "$BRANCH"
    git pull
else
    git clone --depth 1 --branch "$BRANCH" "$TMUX_REPO" "$TMUX_REPO_PATH"
fi

cd "$TMUX_REPO_PATH" || exit

sh ./autogen.sh
./configure
make

sudo make insall
