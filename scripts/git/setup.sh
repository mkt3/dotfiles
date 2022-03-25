#!/usr/bin/env bash

set -eu

setup_git() {
    title "Setting up Git"
    local git_file_dir="$CONFIGS_DIR/git"
    local git_config_dir="${XDG_CONFIG_HOME}/git"

    if [ -d $git_config_dir ]; then
        info "Already exists... Skipping."
    else
        info "Creating symlink for Git"
        ln -sfn $git_file_dir $git_config_dir

        info "Setting up personal info."
        read -rp "Name:" name
        read -rp "Email:" email

        git config --global user.name $name
        git config --global user.email $email

        mv "${HOME}/.gitconfig" "${git_config_dir}/config"

        git config --global url.git@github.com:.insteadOf https://github.com/
    fi
}
