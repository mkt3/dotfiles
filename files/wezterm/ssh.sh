#!/usr/bin/env bash
SSH_CONFIG_FILE_LIST=`bash -c "ls ~/.ssh/*/config" 2> /dev/null`
host_list=""
for ssh_config in ${SSH_CONFIG_FILE_LIST}
do
    for i in `grep "^Host " $ssh_config | grep -v "*" | sed s/"^Host "// | sed s/","/\ /g`
    do
        host_list="${host_list}${i}\n"
    done
done
ssh_host="`echo -e $host_list | ~/.local/share/fzf/bin/fzf --reverse --border --ansi --prompt='Server:' | cut -d: -f1`"
if [[ "$ssh_host" = "" ]]; then
    :
else
    echo -ne "\x1b]0;$ssh_host\x1b\\"
    eval "ssh $ssh_host"
fi