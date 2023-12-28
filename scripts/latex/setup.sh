#!/usr/bin/env bash

set -eu

setup_latex() {
    title "Setting up latex"

    if ! (type dvisvgm > /dev/null 2>&1); then
        sudo tlmgr update --self --all
        sudo tlmgr paper a4
        sudo tlmgr install collection-langjapanese dvisvgm wrapfig capt-of
    fi
}
