#!/usr/bin/env bash

set -eu

setup_skk() {
    title "Setting up skk"

    info "Creating symlink for zsh"
    local skk_rule_path="${XDG_CONFIG_HOME}/libskk/rules"
    mkdir -p "$skk_rule_path"

    ln -sfn "${CONFIGS_DIR}/skk/StickyShift" "${skk_rule_path}/StickyShift"

    info "Building yaskkserv2"
    local yaskkserv2_repo_path="${HOME}/.local/src/yaskkserv2"
    local yaskkserv2_dict_path="${XDG_DATA_HOME}/yaskkserv2"
    if [ -d "$yaskkserv2_repo_path" ]; then
        cd "$yaskkserv2_repo_path"
        git pull
    else
        git clone https://github.com/wachikun/yaskkserv2.git "$yaskkserv2_repo_path"
    fi

    wget -O - http://openlab.jp/skk/dic/SKK-JISYO.L.gz | gzip -d > /tmp/SKK-JISYO.L

    cd "$yaskkserv2_repo_path"
    cargo build --release

    cp -av target/release/yaskkserv2 "${HOME}/.local/bin"
    cp -av target/release/yaskkserv2_make_dictionary "${HOME}/.local/bin"

    mkdir -p "$yaskkserv2_dict_path"
    yaskkserv2_make_dictionary --dictionary-filename="${yaskkserv2_dict_path}/dictionary.yaskkserv2" "${HOME}/Nextcloud/personal_config/skk/aquaskk/skk-jisyo.utf8" "${HOME}/Nextcloud/personal_config/skk/fcitx5skk/user.dict" "${HOME}/Nextcloud/personal_config/skk/ddskk/skk-jisyo.utf8" /tmp/SKK-JISYO.L  > /dev/null

}
