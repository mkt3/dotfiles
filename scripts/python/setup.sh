#!/usr/bin/env bash

set -eu

post_setup_jupyterlab() {
    local python_file_dir="$CONFIGS_DIR/python"

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

post_setup_python() {
    local python_file_dir="$CONFIGS_DIR/python"

    info "Creating symlink for matplotlib"
    ln -sfn "${python_file_dir}/matplotlib" "${XDG_CONFIG_HOME}"
}

post_setup_ruff() {
    info "Creating symlink for ruff"
    local python_file_dir="$CONFIGS_DIR/python"
    if [ "$OS" = "Darwin" ]; then
        eval "ln -sfn ${python_file_dir}/ruff \"${HOME}/Library/Application Support/\""
    fi
    ln -sfn "${python_file_dir}/ruff" "${XDG_CONFIG_HOME}"
}
