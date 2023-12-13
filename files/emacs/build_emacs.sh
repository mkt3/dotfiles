#!/usr/bin/env bash

set -eu
set -o pipefail

# constant value
OS=$(uname -s)
UI=$1
EMACS_REPO="https://github.com/mkt3/emacs.git"
EMACS_REPO_PATH="${HOME}/.local/src/emacs"
BRANCH="master"

case "$UI" in
    gui | cui)
        ;;
    *)
        echo "Please enter one argument: 'gui' or 'cui'."
        exit 1
        ;;
esac

# Install library
case "$OS" in
    Darwin)
        DPENDENCIES="make autoconf gnu-sed gnu-tar grep awk coreutils pkg-config texinfo xz gnutls librsvg little-cms2 jansson tree-sitter webp giflib mailutils libgccjit gcc gmp libjpeg zlib isync msmtp mu terminal-notifier imagemagick enchant"
        # shellcheck disable=SC2086
        brew install $DPENDENCIES
        ;;
    Linux)
        DISTRO=$(awk '{print $1; exit}' /etc/issue)

        case "$DISTRO" in
            Arch)
                DEPENDENCIES="gmp gnutls jansson lcms2 acl dbus gpm ncurses systemd-libs tree-sitter libxml2 zlib libgccjit marksman enchant nuspell hunspell-en_us"

                if [[ "$UI" == "gui" ]]; then
                    DEPENDENCIES="${DEPENDENCIES} alsa-lib fontconfig freetype2 gtk3 gdk-pixbuf2 giflib glib2 gtk3 harfbuzz libice libjpeg-turbo libotf pango libpng librsvg libsm sqlite libtiff libwebp lib32-libwebp libxfixes libxml2 m17n-lib sqlite imagemagick"
                fi
                # shellcheck disable=SC2086
                sudo pacman -S --needed $DEPENDENCIES
                ;;
            Ubuntu)
                DEPENDENCIES="autoconf make texinfo gnutls-bin libgccjit-12-dev libacl1 libc6 libdbus-1-3 libgmp10 libgnutls28-dev libgnutls30 libgpm2 libjansson-dev liblcms2-2 libsystemd0 libtinfo6 libxml2 libxml2-dev zlib1g libtree-sitter-dev libtool-bin enchant-2 nuspell libnuspell-dev hunspell-en-us"
                if [[ "$UI" == "gui" ]]; then
                    DEPENDENCIES="${DEPENDENCIES} libcairo2 libfontconfig1 libfreetype6 libgdk-pixbuf-2.0-0 libgif7 libglib2.0-0 libgtk-3-0 libharfbuzz0b libjpeg8 libm17n-0 libotf1 libpango-1.0-0 libpng16-16 libsvg2-2 libsm6 libtiff5 imagemagick"
                fi
                # shellcheck disable=SC2086
                sudo apt install -y $DEPENDENCIES

                export CFLAGS='-I/usr/lib/gcc/x86_64-linux-gnu/12/include -L/usr/lib/gcc/x86_64-linux-gnu/12'
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
if [ -d "$EMACS_REPO_PATH" ]; then
    cd "$EMACS_REPO_PATH" || exit
    make distclean
    git switch "$BRANCH"
    git pull
else
    git clone --depth 1 --branch "$BRANCH" "$EMACS_REPO" "$EMACS_REPO_PATH"
fi

cd "$EMACS_REPO_PATH" || exit

./autogen.sh

BUILD_OPTIONS="--with-native-compilation=aot --with-tree-sitter --without-x --without-pop --with-mailutils --with-xml2"

if [[ "$OS" == 'Linux' ]]; then
    if [[ "$UI" == 'cui' ]]; then
        BUILD_OPTIONS="--prefix=/usr/local ${BUILD_OPTIONS}"
    else
        BUILD_OPTIONS="--prefix=/usr/local --with-pgtk --with-xwidgets --with-imagemagick ${BUILD_OPTIONS}"
    fi
elif [[ "$OS" == 'Darwin' ]]; then
    BUILD_OPTIONS="${BUILD_OPTIONS} --with-ns --with-xwidgets --with-imagemagick"
fi

# shellcheck disable=SC2086
./configure $BUILD_OPTIONS

make bootstrap -j"$(nproc)"

if [[ "$OS" == 'Linux' ]]; then
    sudo make install
elif [[ "$OS" == 'Darwin' ]]; then
    make install
fi
