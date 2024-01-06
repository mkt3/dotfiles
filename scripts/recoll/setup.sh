#!/usr/bin/env bash

set -eu

pre_setup_recoll() {
    info "Creating symlink for recoll"
    mkdir -p "${XDG_CONFIG_HOME}/recoll"
    ln -sfn "$CONFIGS_DIR/recoll/recoll.conf" "${RECOLL_CONFDIR}"
}

post_setup_recoll() {
    if [ "$OS" = "Darwin" ]; then
        info "Creating symlink for recoll command"
        local recoll_dir="/usr/local/Cellar/recoll"
        local recoll_app_path
        recoll_app_path=$(find "$recoll_dir" -type d -name recoll.app;)

        if [[ "$recoll_app_path" == "$recoll_dir"/* ]]; then
            ln -sfn "$recoll_app_path" /Applications/
        fi
        info "Downloding rclorgmode.py"
        # https://framagit.org/medoc92/recoll/-/issues/38
        rclorgmode_path="${recoll_app_path}/Contents/Resources/filters/rclorgmode.py"
        wget https://framagit.org/medoc92/recoll/-/raw/master/src/filters/rclorgmode.py -O "$rclorgmode_path"

        chmod a+x "$rclorgmode_path"
    fi

}
