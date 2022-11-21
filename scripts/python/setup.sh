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

    if [ $1 != "mac" ] && !(type pipx > /dev/null 2>&1); then
        pip3 install --user pipx
    fi

    info "Installing/Updating pipx packages"
    # package_list=(jupyterlab flake8 isort black pyright)
    package_list=(jupyterlab flake8 isort black pyright)

    installed_list=$(pipx list)

    for package in ${package_list[@]}; do
        if [[ $installed_list =~ "package $package" ]]; then
            info "Updating $package"
            pipx upgrade --include-injected $package
        else
            info "Installing $package"
            pipx install $package

            # if [ $package == "jupyterlab" ]; then
            #     info "Installing jupyterlab template extention"
            #    pipx inject jupyterlab jupyterlab_templates
            # fi
        fi
    done

}

setup_poetry() {
    local poetry_path="${HOME}/.local/bin/poetry"
    if [ ! -L $poetry_path ]; then
        info "Downloading poetry"
        pipx install poetry
    else
        info "Updateing poetry"
        $poetry_path self update || echo 'No update'
    fi

    info "Setting global config"
    $poetry_path config virtualenvs.in-project true
    $poetry_path config virtualenvs.prefer-active-python true

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

    info "Creating symlink for matplotlib"
    ln -sfn "${python_file_dir}/matplotlib" "${XDG_CONFIG_HOME}"

    # info "Creating symlink for jupyterlab.sh"
    # mkdir -p "${HOME}/.local/bin"
    # ln -sfn "${python_file_dir}/jupyterlab.sh" "${HOME}/.local/bin/jupyterlab.sh"

    setup_pyenv

    setup_pipx $1

    setup_poetry

    # setup_jupyterlab
}
