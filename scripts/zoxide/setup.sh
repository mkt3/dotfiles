#!/usr/bin/env bash

set -eu

setup_zoxide() {
    title "Setting up zoxide"

    local install_dir

    local mac_config_dir="${HOME}/Library/Application Support"
    if [ -e "${mac_config_dir}" ]; then
        install_dir="${HOME}/Library/Applicagion Suport/zoxide"
    else
        install_dir="${XDG_DATA_HOME}/zoxide"
    fi

    if [ -d "$install_dir" ]; then
        info "zoxide is already installed."
    else
        info "Installing zoxide"
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

}
