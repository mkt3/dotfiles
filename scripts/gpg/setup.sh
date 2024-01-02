#!/usr/bin/env bash

set -eu

pre_setup_gpg() {
    title "Pre detting up GPG"

    mkdir -p "$GNUPGHOME"
    chmod 700 "$GNUPGHOME"

    local gpg_file_dir="${CONFIGS_DIR}/gpg"

    if [ "$OS" = "Darwin" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_macos.conf" "${GNUPGHOME}/gpg-agent.conf"
    elif [ "$OS" = "Linux" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_linux.conf" "${GNUPGHOME}/gpg-agent.conf"
    fi
}

post_setup_gpg() {
    title "Post setting up GPG"

    local gpg_file_dir="${CONFIGS_DIR}/gpg"

    if [ "$GUI_ENV" = "n" ]; then
        systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket
        ln -sfn "${gpg_file_dir}/gpg.conf" "${GNUPGHOME}/gpg.conf"
    fi
}
