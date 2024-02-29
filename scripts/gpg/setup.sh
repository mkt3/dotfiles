#!/usr/bin/env bash

set -eu

pre_setup_gpg() {
    info "Creating symlink for gpg-agent.conf"

    mkdir -p "$GNUPGHOME"
    chmod 700 "$GNUPGHOME"

    local gpg_file_dir="${CONFIGS_DIR}/gpg"

    if [ "$OS" = "Darwin" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_macos.conf" "${GNUPGHOME}/gpg-agent.conf"
        eval "ln -sfn \"${HOME}/Applications/Home Manager Apps/pinentry-mac.app/Contents/MacOS/pinentry-mac\" /usr/local/bin/"
    elif [ "$OS" = "Linux" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_linux.conf" "${GNUPGHOME}/gpg-agent.conf"
    fi
}

post_setup_gpg() {
    local gpg_file_dir="${CONFIGS_DIR}/gpg"

    if [ "$GUI_ENV" = "n" ]; then
        info "Disable gpg-agent.service"
        systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket
        ln -sfn "${gpg_file_dir}/gpg.conf" "${GNUPGHOME}/gpg.conf"
    fi
}
