#!/usr/bin/env bash

set -eu

setup_font() {
    title "Setting up font"

    info "Add cica conf"
    local font_dir="${XDG_DATA_HOME}/fonts/Cica"
    local font_name="Cica"

    if bash -lc "fc-match $font_name | grep ${font_name} > /dev/null"; then
        info "Cica font already exists... Skipping."
        return 0
    fi

    sudo mkdir -p $font_dir
    local cica_download_path="/tmp/Cica.zip"
    sudo curl -fL -o $cica_download_path https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip

    sudo unzip -d $font_dir $cica_download_path

    sudo fc-cache -vf
}
