#!/usr/bin/env bash

set -eu

setup_font() {
    title "Setting up font"

    info "Noto font"
    mkdir -p "${XDG_CONFIG_HOME}/fontconfig/conf.d"
    ln -sf "${CONFIGS_DIR}/font/99-system_fonts.conf" "${XDG_CONFIG_HOME}/fontconfig/conf.d/"

    info "Add cica font"
    local cica_font_dir="${XDG_DATA_HOME}/fonts/Cica"
    local cica_font_name="Cica"

    if bash -lc "fc-match $cica_font_name | grep ${cica_font_name} > /dev/null"; then
        info "Cica font already exists... Skipping."
        return 0
    fi

    local cica_download_path="/tmp/Cica.zip"
    sudo curl -fL -o $cica_download_path https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip

    unar $cica_download_path -D -o "$cica_font_dir"

    fc-cache -vf
}
