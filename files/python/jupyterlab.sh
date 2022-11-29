#!/usr/bin/env bash

WORKSPACE_DIR=$HOME/workspace/*/*/*/
INSTALLE_DIR=$HOME/.local/share/jupyter/kernels

projects=($(ls ${WORKSPACE_DIR}))
installs=($(ls ${INSTALLE_DIR}))

for install in ${installs[@]}; do
    rm -rf ${INSTALLE_DIR}/${install}
done

for project in ${projects[@]}; do
    if [ -f ${WORKSPACE_DIR}/${project}/.venv/bin/python ]; then
        ${WORKSPACE_DIR}/${project}/.venv/bin/python -m ipykernel install --user --name=${project} --display-name=${project}
    fi
done

jupyter-lab --ip 0.0.0.0
