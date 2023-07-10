#!/usr/bin/env bash

set -eu

setup_gpg() {
    title "Setting up GPG"

    mkdir -p "$GNUPGHOME"
    chmod 700 "$GNUPGHOME"

    local gpg_file_dir="${CONFIGS_DIR}/gpg"

    if [ "$UI" = "cui" ]; then
        systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket
        ln -sfn "${gpg_file_dir}/gpg.conf" "${GNUPGHOME}/gpg.conf"
    fi

    if [ "$OS" = "Darwin" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_macos.conf" "${GNUPGHOME}/gpg-agent.conf"
    elif [ "$OS" = "Linux" ]; then
        ln -sfn "${gpg_file_dir}/gpg-agent_for_linux.conf" "${GNUPGHOME}/gpg-agent.conf"
    fi

}
