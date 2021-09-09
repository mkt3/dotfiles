#!/bin/bash

set -e

os=$(uname -s | tr '[A-Z]' '[a-z]')

if [ $# -eq 1 ] && [ $1 = "minimal" ]; then
    os="minimal"
fi

case $os in
    darwin)
        PLAYBOOK=ansible-playbook/mac.yml
    ;;
    linux)
        dist=$(cat /etc/issue | tr '[A-Z]' '[a-z]')
        case $dist in
            arch*)
                PLAYBOOK=ansible-playbook/arch.yml
            ;;
            ubuntu*)
                if systemctl get-default | grep 'graphical.target' > /dev/null 2>&1; then
                    PLAYBOOK="ansible-playbook/ubuntu_gui.yml -K"
                else
                    PLAYBOOK="ansible-playbook/ubuntu_cui.yml -K"
                fi
            ;;
            *photon*)
                PLAYBOOK=ansible-playbook/photon.yml
            ;;
        esac
    ;;
    minimal)
         PLAYBOOK=ansible-playbook/minimal.yml
    ;;
esac

echo "run playbook: $PLAYBOOK"
ansible-playbook --verbose -i ansible-playbook/local $PLAYBOOK
