#!/usr/bin/env bash

set -eu

setup_pipx() {
    info "Setting up pipx"

    if [ "$OS" != "darwin" ] && ! (type pipx > /dev/null 2>&1); then
        pip3 install --user pipx
    fi

    info "Installing/Updating pipx packages"
    local package_list=(jupyterlab black pyright ruff)

    local installed_list=$(pipx list)

    for package in "${package_list[@]}"; do
        if [[ $installed_list =~ "package $package" ]]; then
            info "Updating $package"
            pipx upgrade --include-injected "$package"
        else
            info "Installing $package"
            pipx install "$package"

            if [ $package == "jupyterlab" ]; then
                info "Installing jupyterlab template extention"
               pipx inject jupyterlab jupyterlab_templates
            fi
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

    pip3 install --user i3ipc

    info "Creating symlink for matplotlib"
    ln -sfn "${python_file_dir}/matplotlib" "${XDG_CONFIG_HOME}"

    info "Creating symlink for ruff"
    ln -sfn "${python_file_dir}/ruff" "${XDG_CONFIG_HOME}"

    info "Creating symlink for jupyterlab.sh"
    mkdir -p "${HOME}/.local/bin"
    ln -sfn "${python_file_dir}/jupyterlab.sh" "${HOME}/.local/bin/jupyterlab.sh"

    setup_pipx

    setup_poetry

    setup_jupyterlab
}
