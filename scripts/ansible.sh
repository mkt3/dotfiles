  
#!/bin/bash

set -e

os=$(uname -s | tr '[A-Z]' '[a-z]')

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
                if type dconf > /dev/null 2>&1; then
                    PLAYBOOK=ansible-playbook/ubuntu_gui.yml
                else
                    PLAYBOOK=ansible-playbook/ubuntu_cui.yml
                fi
            ;;
         esac
    ;;
esac

echo "run playbook: $PLAYBOOK"
ansible-playbook --verbose -i ansible-playbook/local $PLAYBOOK
