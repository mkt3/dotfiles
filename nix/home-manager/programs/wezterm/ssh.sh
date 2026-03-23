#!/usr/bin/env bash

set -euo pipefail

if [ -f "${HOME}/.zshenv" ]; then
  . "${HOME}/.zshenv"
fi

ssh_config_file="${HOME}/.ssh/extra_config"
host_list=""

if [ ! -r "$ssh_config_file" ]; then
  exit 0
fi

while IFS= read -r line; do
  if [[ $line =~ ^Host ]] && [[ ! $line =~ \* ]]; then
    hosts="${line#Host }"
    hosts="${hosts//,/ }"
    for host in $hosts; do
      host_list+="${host}\n"
    done
  fi
done < "$ssh_config_file"


if ! ssh_host=$(echo -e "$host_list" | fzf --reverse --border --ansi --prompt='Server:' | cut -d: -f1); then
  exit 0
fi
if [[ "$ssh_host" = "" ]]; then
    :
else
    echo -ne "\x1b]0;$ssh_host\x1b\\"
    if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
        SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh" ssh -- "$ssh_host"
    else
        SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" ssh -- "$ssh_host"
    fi
fi
