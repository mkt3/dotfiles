#!/usr/bin/env bash

set -eu

setup_font() {
    title "Setting up font"

    info "Add cica conf"
    local font_dir="/usr/share/fonts/Cica"
    local font_name="Cica"

    if bash -lc "fc-match | grep ${font_name} > /dev/null"; then
        info "Cica font already exists... Skipping."
        return 0
    fi

    mkdir -p $font_dir
    local cica_download_path="/tmp/Cica.zip"
    curl -fL -o $cica_download_path https://github.com/miiton/Cica/releases/download/v5.0.2/Cica_v5.0.2_with_emoji.zip

    unzip -d $font_dir $cica_download_path

    fc-cache -vf
}
