. "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit load zsh-users/zsh-completions
zinit load zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit load "b4b4r07/enhancd"
zinit ice atload'!_zsh_git_prompt_precmd_hook' lucid
zinit load woefe/git-prompt.zsh

# Prompt
autoload -U colors
colors

## Left prompt
if [ -n "${SSH_CONNECTION}" ]; then
    local host_color="cyan"

else
    local host_color="green"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

setopt prompt_subst
function _vcs_precmd {
    V_ENV="($VIRTUAL_ENV:h:t)"
    if [[ "$V_ENV" == "(.)" ]]; then
        V_ENV=""
    fi
    PROMPT='%U%{%(?.${fg[$host_color]}.${fg[red]})%}[%n@%m]%{${reset_color}%}%u$(gitprompt)%~'$'\n''$V_ENV%# '
}

add-zsh-hook precmd _vcs_precmd

# Setopt
setopt auto_cd
setopt auto_pushd
setopt no_beep
setopt no_list_beep
#setopt sh_word_split

# Command history
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Keybind
bindkey -e
## historical backward/forward search with linehead string bined to ^
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Completion
fpath+=$HOME/.zfunc
autoload -U compinit
compinit -u
setopt auto_list
setopt list_packed
setopt auto_param_keys
setopt auto_param_slash
setopt mark_dirs
setopt list_types
setopt auto_menu
setopt complete_in_word
setopt magic_equal_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 

# Ls colors 
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors "${LS_COLORS}"

# rehash
zstyle ":completion:*:commands" rehash 1

# comment
setopt INTERACTIVE_COMMENTS

# Alias
setopt complete_aliases

case "${PLATFORM}" in
    osx)
        alias ssh="~/.ssh/bin/ssh_change.sh"
        alias sed="gsed"
        ;;
    linux)
        alias open="xdg-open"
        ;;
esac

alias rm="rm -i"
alias emacs="emacs -nw"
alias cp="cp -i"
alias mv="mv -i"
alias grep='grep --color=auto'
alias x="exit"
alias cdh="cd ~/"
alias sudo='TERM=xterm-256color sudo'
alias dc='docker-compose'
compdef dc=docker-compose

if type bat > /dev/null 2>&1; then
    alias cat='bat'
    alias find='fd'
    alias diff="delta"
    alias ls='lsd'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias jl='~/.local/bin/jupyterlab.sh'

chpwd() {
    ls
}

# Config for each environment
if [ -e $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

# Emacs tramp config for zsh
if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
#export FZF_CTRL_T_COMMAND=rg --files --hidden --follow --glob "!.git/*"
#export FZF_CTRL_T_OPTS=--preview "bat  --color=always --style=header,grid --line-range :100 {}"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_OPTS="--preview 'bat  --color=always --style=header,grid --line-range :100 {}'"

# poetry config
if type "poetry" > /dev/null 2>&1; then
    poetry config virtualenvs.in-project true
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/gcp/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/gcp/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/gcp/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/gcp/google-cloud-sdk/completion.zsh.inc"; fi


# Tmux config
SSH_CONFIG_FILE_LIST=`ls ~/.ssh/*/config  2>/dev/null`

host_list=""
for ssh_config in ${=SSH_CONFIG_FILE_LIST}
do
    for i in `grep "^Host " $ssh_config | grep -v "*" | sed s/"^Host "// | sed s/","/\ /g`
    do
        host_list="${i} ${host_list}"
        ssh_command_list="${ssh_command_list}ssh ${i}:\n"
    done
done

ssh_command_list=""
for i in ${=host_list}
do
    ssh_command_list="${ssh_command_list}ssh ${i}:\n"
done

export PERCOL=fzf

if [[ ! -n $TMUX && $- == *l* && "$TERM" != "dumb" ]]; then
    ID="`tmux list-sessions`"
    create_new_session="Create new session"
    if [[ -z "$ID" ]]; then
       ID="${create_new_session}:\n${ssh_command_list}"
    else
       ID="$ID\n${create_new_session}:\n${ssh_command_list}"
    fi
    ID="`echo $ID | $PERCOL | cut -d: -f1`"
    if [[ "$ID" = "${create_new_session}" ]]; then
       tmux new-session
    elif [[ `echo $ID | grep ssh` ]]; then
       eval $ID
    elif [[ -n "$ID" ]]; then
       tmux attach-session -t "$ID"
    else
       :  # Start terminal normally
    fi
 fi
