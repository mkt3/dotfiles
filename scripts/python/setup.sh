#!/usr/bin/env bash

set -eu

setup_pipx() {
    info "Setting up pipx"

    info "Installing/Updating pipx packages"
    # local package_list=(jupyterlab black pyright ruff)
    local package_list=(black pyright ruff)

    local installed_list
    installed_list=$(pipx list)

    for package in "${package_list[@]}"; do
        if [[ $installed_list =~ package\ "$package" ]]; then
            info "Updating $package"
            pipx upgrade --include-injected "$package"
        else
            info "Installing $package"
            pipx install "$package"

            if [ "$package" == "jupyterlab" ]; then
                info "Installing jupyterlab template extention"
               pipx inject jupyterlab jupyterlab_templates
            fi
        fi
    done

}

setup_poetry() {
    local poetry_path="${HOME}/.local/bin/poetry"
    if [ ! -L "$poetry_path" ]; then
        info "Installing poetry"
        pipx install poetry
    else
        info "Updating poetry"
        pipx upgrade --include-injected poetry

    fi

    info "Setting global config"
    $poetry_path config virtualenvs.in-project true
    $poetry_path config virtualenvs.prefer-active-python true

    info "Enable completions"
    $poetry_path completions zsh > "${ZSH_COMPLETION_DIR}/_poetry"
}


setup_jupyterlab() {
    info "Creating symlink for jupyterlab.sh"
    mkdir -p "${HOME}/.local/bin"
    ln -sfn "${python_file_dir}/jupyterlab.sh" "${HOME}/.local/bin/jupyterlab.sh"

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

    info "Creating symlink for matplotlib"
    ln -sfn "${python_file_dir}/matplotlib" "${XDG_CONFIG_HOME}"

    info "Creating symlink for ruff"
    if [ "$OS" = "Darwin" ]; then
        eval "ln -sfn ${python_file_dir}/ruff \"${HOME}/Library/Application Support/\""
    else
        ln -sfn "${python_file_dir}/ruff" "${XDG_CONFIG_HOME}"
    fi

    setup_pipx

    setup_poetry

    # setup_jupyterlab
}
