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
    local skk_dict_dir_path="${HOME}/Nextcloud/personal_config/skk/downloaded_skk_dict"
    local skk_dict_url_list=("https://skk-dev.github.io/dict/SKK-JISYO.L.gz"
                             "https://skk-dev.github.io/dict/SKK-JISYO.jinmei.gz"
                             "https://skk-dev.github.io/dict/SKK-JISYO.propernoun.gz")

    local skk_dict_path_list=("${HOME}/Nextcloud/personal_config/skk/aquaskk/skk-jisyo.utf8"
                              "${HOME}/Nextcloud/personal_config/skk/fcitx5skk/user.dict"
                              "${HOME}/Nextcloud/personal_config/skk/ddskk/skk-jisyo.utf8")

    if [ -d "$yaskkserv2_repo_path" ]; then
        cd "$yaskkserv2_repo_path"
        git pull
    else
        git clone https://github.com/wachikun/yaskkserv2.git "$yaskkserv2_repo_path"
    fi

    local dict_name=""
    for url in "${skk_dict_url_list[@]}"; do
        dict_name=$(basename "$url" .gz)
        local skk_dict_path="${skk_dict_dir_path}/${dict_name}"
        skk_dict_path_list+=("$skk_dict_path")
        if [ ! -e "$skk_dict_path" ]; then
            wget -O - "$url" | gzip -d > "$skk_dict_path"
        fi
    done

    cd "$yaskkserv2_repo_path"
    cargo build --release

    cp -a target/release/yaskkserv2 "${HOME}/.local/bin"
    cp -a target/release/yaskkserv2_make_dictionary "${HOME}/.local/bin"

    info "Building yaskkserv2 dictionary"
    mkdir -p "$yaskkserv2_dict_path"
    yaskkserv2_make_dictionary --dictionary-filename="${yaskkserv2_dict_path}/dictionary.yaskkserv2" "${skk_dict_path_list[@]}" > /dev/null
}
