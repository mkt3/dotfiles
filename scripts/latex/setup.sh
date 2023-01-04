#!/usr/bin/env bash

set -eu

setup_latex() {
    title "Setting up latex"

    if ! (type latex > /dev/null 2>&1); then
        brew install --cask basictex
        sudo tlmgr update --self --all
        sudo tlmgr paper a4
        sudo tlmgr install collection-langjapanese
        sudo tlmgr install dvisvgm
    fi
}
