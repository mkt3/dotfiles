#!/usr/bin/env bash

set -eu

setup_pyenv() {
    info "Setting up pyenv"
    local pyenv_git_url="https://github.com/pyenv/pyenv.git"
    local install_dir="${XDG_DATA_HOME}/pyenv"

    if [ -d $install_dir ]; then
        info "Updating pyenv repository"
        git -C $install_dir pull
    else
        info "Clonening pyenv repository"
        git clone --depth 1 $pyenv_git_url $install_dir
    fi
}

setup_pipx() {
    info "Setting up pipx"

    if !(type pipx > /dev/null 2>&1); then
        pip3 install --user pipx
    fi

    info "Installing pipx packages"
    package_list=(jupyterlab flake8 isort black)
    for package in ${package_list[@]}; do
        info "$package ..."
        pipx install $package
    done

    info "Installing jupyterlab template extention"
    pipx inject jupyterlab jupyterlab_templates
}

setup_poetry() {
    local poetry_path="${HOME}/.local/bin/poetry"
    if [ ! -e poetry_path ]; then
        info "Downloading poetry"
        pipx install git+https://github.com/python-poetry/poetry.git
    else
        info "Updateing poetry"
        $poetry_path self update
    fi

    if  bash -lc "~/.local/bin/poetry config --list | grep 'virtualenvs.in-project = true' > /dev/null"; then
        info "Global config already exists... Skipping."
    else
        info "Setting global config"
        $poetry_path config virtualenvs.in-project true
    fi

    info "Enable completions"
    $poetry_path completions zsh > "${ZSH_COMPLETION_DIR}/_poetry"
    
    info "Creating symlink for poetry"
    mkdir -p "${HOME}/.local/bin"
    ln -sfn "${python_file_dir}/peu" "${HOME}/.local/bin/peu"
    ln -sfn "${python_file_dir}/_peu" "${XDG_DATA_HOME}/zsh/completion/_peu"
}


setup_jupyterlab() {
    local python_file_dir="$CONFIGS_DIR/python"
    info "Creating directory for jupyter"
    mkdir -p "${XDG_CONFIG_HOME}/jupyter"
    mkdir -p "${XDG_DATA_HOME}/jupyter"

    info "Creating symlink for jupyterlab"
    mkdir -p "${HOME}/.local/bin"
    ln -sfn "${python_file_dir}/jupyterlab.sh" "${HOME}/.local/bin/jupyterlab.sh"

    ln -sfn "${python_file_dir}/jupyter_lab_config.py" "${XDG_CONFIG_HOME}/jupyter/jupyter_lab_config.py"

    ln -sfn "${python_file_dir}/notebook_templates" "${XDG_DATA_HOME}/jupyter/notebook_templates"

}

setup_python() {
    title "Setting up python"
    local python_file_dir="$CONFIGS_DIR/python"

    info "Creating symlink for flake8"
    ln -sfn "${python_file_dir}/flake8" "${XDG_CONFIG_HOME}/flake8"

    info "Creating symlink for jupyterlab.sh"
    mkdir -p "${HOME}/.local/bin"
    ln -sfn "${python_file_dir}/jupyterlab.sh" "${HOME}/.local/bin/jupyterlab.sh"

    setup_pyenv

    if [ $1 == "ubuntu" ]; then
        setup_pipx
    fi
    setup_poetry

    setup_jupyterlab
}
