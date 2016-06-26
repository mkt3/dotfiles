## PROMPT
autoload -U colors
colors

if [ -n "${SSH_CONNECTION}" ]; then
    local host_color="cyan"

else
    local host_color="green"
fi

PROMPT="%U%{%(?.${fg[$host_color]}.${fg[red]})%}[%n@%m]%{${reset_color}%}%u(%j) %~
%# "

RPROMPT="%1(v|%F{green}%1v%f|)"

## setopt
setopt auto_cd
setopt auto_pushd
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt auto_param_keys
setopt auto_param_slash
setopt magic_equal_subst

## Command history
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups
setopt share_history
setopt extended_history

## Keybind
bindkey -e
# historical backward/forward search with linehead string bined to ^
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Completion
autoload -U compinit
compinit -u

## ls colors 
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## Alias
setopt complete_aliases

alias ls="ls -FGh"
alias ll="ls -l"
alias la="ls -aF"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias grep='grep --color=auto'
alias x="exit"

