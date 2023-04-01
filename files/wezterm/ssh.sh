#!/usr/bin/env bash

ssh_config_file=`bash -c "ls ~/.ssh/config" 2> /dev/null`
host_list=""
for i in `grep "^Host " $ssh_config_file | grep -v "*" | sed s/"^Host "// | sed s/","/\ /g`
do
    host_list="${host_list}${i}\n"
done
ssh_host="`echo -e $host_list | ~/.local/share/fzf/bin/fzf --reverse --border --ansi --prompt='Server:' | cut -d: -f1`"
if [[ "$ssh_host" = "" ]]; then
    :
else
    echo -ne "\x1b]0;$ssh_host\x1b\\"
    if [[ "$XDG_RUNTIME_DIR" = "" ]]; then
        eval "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh ssh $ssh_host"
    else
        eval "SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh ssh $ssh_host"
    fi
fi
