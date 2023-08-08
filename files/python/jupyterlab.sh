#!/usr/bin/env bash

WORKSPACE_DIR="$HOME/workspace/*/*/*/"
INSTALLED_DIR="$HOME/.local/share/jupyter/kernels"

mapfile -t projects < <(find "${WORKSPACE_DIR}" -maxdepth 1 -mindepth 1 -type d -printf "%f\n")

rm -rf "${INSTALLED_DIR:?}"/*

for project in "${projects[@]}"; do
    if [ -f "${WORKSPACE_DIR}/${project}/.venv/bin/python" ]; then
        "${WORKSPACE_DIR}/${project}/.venv/bin/python" -m ipykernel install --user --name="${project}" --display-name="${project}"
    fi
done

jupyter-lab --ip 0.0.0.0
