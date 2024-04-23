#!/usr/bin/env bash

set -eu

post_setup_git() {
    local git_file_dir="$CONFIGS_DIR/git"
    local git_config_dir="${XDG_CONFIG_HOME}/git"

    if [ -d "$git_config_dir" ]; then
        info "Already exists config file."
    else
        info "Creating git config file"
        mkdir -p "$git_config_dir"
        touch "${git_config_dir}/config"
    fi

    ln -sfn "${git_file_dir}/ignore" "${git_config_dir}/"

    info "Setting up git"
    git config --global pull.rebase false

    git config --global url.git@github.com:.pushInsteadOf https://github.com/

    git config --global init.defaultBranch main

    git config --global fetch.prune true

    git config --global core.ignorecase false

    git config --global commit.gpgsign true

    git config --global merge.conflictstyle diff3

    git config --global diff.colorMoved default

    # delta
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
}

post_setup_git-secrets() {
    local git_config_dir="${XDG_CONFIG_HOME}/git"

    # for AWS
    git-secrets --register-aws --global
    # for GCP
    git-secrets --add 'private_key' --global || true
    git-secrets --add 'private_key_id' --global || true
    git-secrets --install "${git_config_dir}/git-templates/git-secrets" || true
    git config --global init.templatedir "${git_config_dir}/git-templates/git-secrets"
}
