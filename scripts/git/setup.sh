#!/usr/bin/env bash

set -eu

setup_git() {
    title "Setting up Git"
    local git_file_dir="$CONFIGS_DIR/git"
    local git_config_dir="${XDG_CONFIG_HOME}/git"

    if [ -d $git_config_dir ]; then
        info "Already exists config file."
    else
        info "Creating git config file"
        mkdir -p $git_config_dir
        touch "${git_config_dir}/config"
    fi

    ln -sfn "${git_file_dir}/ignore" "${git_config_dir}/"

    info "Setting up git"
    git config --global pull.rebase false

    git config --global url.git@github.com:.insteadOf https://github.com/

    git config --global init.defaultBranch main

    # delta
    git config --global delta.navigate true 
    git config --global delta.light false 
    git config --global delta.line-numbers true 
}
