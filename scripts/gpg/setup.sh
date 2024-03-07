#!/usr/bin/env bash

set -eu

post_setup_gpg() {
    if [ "$GUI_ENV" = "n" ]; then
        info "Disable gpg-agent.service"
        systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket
        echo "no-autostart" > "${GNUPGHOME}/gpg.conf"
    fi
}
