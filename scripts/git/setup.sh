#!/usr/bin/env bash

set -eu

setup_git() {
    title "Setting up Git"
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

    if ! (type git-secrets > /dev/null 2>&1); then
        local git_secrets_dir="${HOME}/.local/src/git-secrets"
        info "Installing git-secrets"
        git clone https://github.com/awslabs/git-secrets.git "$git_secrets_dir"
        /bin/bash -c "$(cd $git_secrets_dir && PREFIX="${HOME}/.local" make install)"

        # for AWS
        git secrets --register-aws --global
        # for GCP
        git secrets --add 'private_key' --global
        git secrets --add 'private_key_id' --global

        git secrets --install "${git_config_dir}/git-templates/git-secrets" || true
        git config --global init.templatedir "${git_config_dir}/git-templates/git-secrets"
    fi

    info "Setting up git"
    git config --global pull.rebase false

    git config --global url.git@github.com:.insteadOf https://github.com/

    git config --global init.defaultBranch main

    git config --global fetch.prune true

    git config --global core.ignorecase false

    git config --global commit.gpgsign true

    # delta
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true
}
