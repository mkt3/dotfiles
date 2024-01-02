#!/usr/bin/env bash

set -eu

post_setup_skk() {
    title "Setting up skk"

    info "Creating symlink for zsh"
    local skk_rule_path="${XDG_CONFIG_HOME}/libskk/rules"
    mkdir -p "$skk_rule_path"

    ln -sfn "${CONFIGS_DIR}/skk/StickyShift" "${skk_rule_path}/StickyShift"

    info "Building yaskkserv2"
    local yaskkserv2_repo_path="${HOME}/.local/src/yaskkserv2"
    local yaskkserv2_dict_path="${XDG_DATA_HOME}/yaskkserv2"
    local skk_dict_repo_path="${HOME}/Nextcloud/personal_config/skk/dict"

    local skk_dict_path_list=("${HOME}/Nextcloud/personal_config/skk/aquaskk/skk-jisyo.utf8"
                              "${HOME}/Nextcloud/personal_config/skk/fcitx5skk/user.dict"
                              "${HOME}/Nextcloud/personal_config/skk/ddskk/skk-jisyo.utf8"
                              "${skk_dict_repo_path}/SKK-JISYO.L"
                              "${skk_dict_repo_path}/SKK-JISYO.jinmei"
                              "${skk_dict_repo_path}/SKK-JISYO.propernoun")


    if [ ! -d "${HOME}/Nextcloud/personal_config/skk" ]; then
        return
    fi

    if [ -d "$yaskkserv2_repo_path" ]; then
        cd "$yaskkserv2_repo_path"
        git pull
    else
        git clone https://github.com/wachikun/yaskkserv2.git "$yaskkserv2_repo_path"
    fi

    cd "$yaskkserv2_repo_path"
    "${CARGO_HOME}/bin/rustup" run stable cargo build --release

    ln -sfn "${yaskkserv2_repo_path}/target/release/yaskkserv2" "${HOME}/.local/bin"
    ln -sfn "${yaskkserv2_repo_path}/target/release/yaskkserv2_make_dictionary" "${HOME}/.local/bin"

    info "Updating skk dictionary"
    if [ -d "$skk_dict_repo_path" ]; then
        cd "$skk_dict_repo_path"
        git pull
    else
        git clone https://github.com/skk-dev/dict.git "$skk_dict_repo_path"
    fi

    info "Building yaskkserv2 dictionary"
    mkdir -p "$yaskkserv2_dict_path"
    yaskkserv2_make_dictionary --dictionary-filename="${yaskkserv2_dict_path}/dictionary.yaskkserv2" "${skk_dict_path_list[@]}" > /dev/null
}
