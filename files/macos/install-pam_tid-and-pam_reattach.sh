#!/usr/bin/env bash
set -e
set -o pipefail

# Switch pam_tid.so path for M1 and x86 chips
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    PAM_REATTACH_PATH="/opt/homebrew/lib/pam/pam_reattach.so"
elif [[ "$ARCH" == "x86_64" ]]; then
    PAM_REATTACH_PATH="/usr/local/lib/pam/pam_reattach.so"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Enable TouchID with sudo
if ! grep -Eq "^auth\s.*\spam_tid.so$" /etc/pam.d/sudo; then
  ( set -e; set -o pipefail
    # Add pam_tid.so as the first auth
    pam_sudo=$(awk 'fixed||!/^auth /{print} !fixed&&/^auth/{print "auth       sufficient     pam_tid.so";print;fixed=1}' /etc/pam.d/sudo)
    sudo tee /etc/pam.d/sudo <<<"$pam_sudo"
  )
fi

# Enable TouchID with sudo inside tmux
if ! grep -Eq "^auth\s.*\s$PAM_REATTACH_PATH$" /etc/pam.d/sudo; then
  ( set -e; set -o pipefail
    # Install pam_reattach.so if it does not exist
    if [[ ! -x $PAM_REATTACH_PATH ]]; then
        brew install pam-reattach
    fi

    # Check existence of pam_reattach.so after installation
    test -f $PAM_REATTACH_PATH || { echo "Failed to install pam_reattach. Check PAM_REATTACH_PATH"; exit 1; }

    # Add pam_reattach.so before pam_tid.so
    pam_sudo=$(awk -v reattachpath="$PAM_REATTACH_PATH" 'fixed||!/^auth .* pam_tid.so$/{print} !fixed&&/^auth/{print "auth       optional       " reattachpath;print;fixed=1}' /etc/pam.d/sudo)
    sudo tee /etc/pam.d/sudo <<<"$pam_sudo"
  )
fi
