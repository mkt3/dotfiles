#!/usr/bin/env bash

# constnt value
OS=$(uname -s)

TMUX_REPO="https://github.com/tmux/tmux.git"
TMUX_REPO_PATH="${HOME}/.local/src/tmux"
TAG="3.3a"

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
    make clean
    git pull
else
    git clone "$TMUX_REPO" "$TMUX_REPO_PATH"
    cd "$TMUX_REPO_PATH" || exit
fi

git checkout "$TAG"

sh ./autogen.sh
./configure

make -j"$(nproc)"

sudo make install
