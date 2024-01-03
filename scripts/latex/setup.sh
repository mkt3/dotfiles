#!/usr/bin/env bash

set -eu

post_setup_latex() {
    info "Installing dvisvgm"
    if ! (type dvisvgm > /dev/null 2>&1); then
        sudo tlmgr update --self --all
        sudo tlmgr paper a4
        sudo tlmgr install collection-langjapanese dvisvgm wrapfig capt-of
    fi
}
