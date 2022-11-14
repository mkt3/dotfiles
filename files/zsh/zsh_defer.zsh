#!/bin/zsh
# plugin
zinit wait lucid blockf light-mode for \
    atinit"zstyle ':autocomplete:*' insert-unambiguous yes" \
    atinit"zstyle ':autocomplete:*' fzf-completion yes" \
    atinit"zstyle ':autocomplete:recent-dirs' backend zoxide" \
    atload"bindkey '^P' history-beginning-search-backward-end" \
    atload"bindkey '^N' down-line-or-select" \
    atload"bindkey -M menuselect '^P' vi-up-line-or-history" \
    atload"bindkey -M menuselect '^N' vi-down-line-or-history" \
    atload"bindkey -M menuselect '\r' accept-line" \
    @'marlonrichert/zsh-autocomplete' \
    @'zsh-users/zsh-completions' \
    @'zsh-users/zsh-autosuggestions' \
    @'zsh-users/zsh-syntax-highlighting' \
    @'olets/zsh-abbr' \
    @'b4b4r07/enhancd'

# Keybind
## historical backward/forward search with linehead string bined to ^
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# rehash
zstyle ":completion:*:commands" rehash 1

# comment
setopt INTERACTIVE_COMMENTS

# fzf
[ -f ~/.config/fzf/fzf.zsh ] && source ~/.config/fzf/fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse --border --ansi'
export FZF_DEFAULT_OPTS='--reverse --border --ansi'

export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --ignore-file=$XDG_CONFIG_HOME/ripgrep/ignore"
export FZF_CTRL_T_OPTS="--preview 'bat  --color=always --style=header,grid --line-range :100 {}'"

export FZF_TMUX_OPTS="-p 80%"

# terminal title
echo -ne "\x1b]0;$HOST\x1b\\"

# Alias
setopt complete_aliases

case "${PLATFORM}" in
    osx)
        (( ${+commands[gdate]} )) && alias date='gdate'
        (( ${+commands[gls]} )) && alias ls='gls'
        (( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
        (( ${+commands[gcp]} )) && alias cp='gcp'
        (( ${+commands[gmv]} )) && alias mv='gmv'
        (( ${+commands[grm]} )) && alias rm='grm'
        (( ${+commands[gdu]} )) && alias du='gdu'
        (( ${+commands[ghead]} )) && alias head='ghead'
        (( ${+commands[gtail]} )) && alias tail='gtail'
        (( ${+commands[gawk]} )) && alias awk='gawk'
        (( ${+commands[gsed]} )) && alias sed='gsed'
        (( ${+commands[ggrep]} )) && alias grep='ggrep'
        (( ${+commands[gfind]} )) && alias find='gfind'
        (( ${+commands[gdirname]} )) && alias dirname='gdirname'
        (( ${+commands[gxargs]} )) && alias xargs='gxargs'
        alias ssh="~/.ssh/bin/ssh_change.sh"
        ;;
    linux)
        alias open="xdg-open"
        ;;
esac

alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias sudo='TERM=xterm-256color sudo'
alias grep="grep --color=auto"
alias emacs="emacs -nw"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias history="history -i"

if [ -e "$NVM_DIR/nvm.sh" ]; then
    alias nvm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && nvm'
    alias node='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && node'
    alias npm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && npm'
fi


# Ls colors
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors "${LS_COLORS}"

if type lsd > /dev/null 2>&1; then
    alias ls='lsd -F'
else
    alias ls='ls --color=auto'
fi

alias jl='~/.local/bin/jupyterlab.sh'
alias ta='~/.local/bin/tmux_session.sh'

chpwd() {
    ls
}

# Emacs tramp config for zsh
if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

# Completion
fpath+=$ZSH_COMPLETION_DIR
autoload -Uz compinit && compinit

# Navi
_navi_call() {
    local result="$(navi "$@" </dev/tty)"
    printf "%s" "$result"
}

_navi_widget() {
    local -r input="${LBUFFER}"
    local -r last_command="$(echo "${input}" | navi fn widget::last_command)"
    local replacement="$last_command"

    if [ -z "$last_command" ]; then
        replacement="$(_navi_call --print)"
    elif [ "$LASTWIDGET" = "_navi_widget" ] && [ "$input" = "$previous_output" ]; then
        replacement="$(_navi_call --print --query "$last_command")"
    else
        replacement="$(_navi_call --print --best-match --query "$last_command")"
    fi

    if [ -n "$replacement" ]; then
        local -r find="${last_command}_NAVIEND"
        previous_output="${input}_NAVIEND"
        previous_output="${previous_output//$find/$replacement}"
    else
        previous_output="$input"
    fi

    zle kill-whole-line
    LBUFFER="${previous_output}"
    region_highlight=("P0 100 bold")
    zle redisplay
}

zle -N _navi_widget

(( ${+commands[navi]} )) &&  bindkey '^s' _navi_widget

# for delta bat completion
compdef _gnu_generic bat delta

# zoxide
eval "$(zoxide init zsh --cmd j)"

function t()
{
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

# pyenv init
[ -d $PYENV_ROOT ] && eval "$(pyenv init -)"

# gcp
export CLOUDSDK_PYTHON=python3.8
if [[ $SETUP != "TRUE" ]];then
   [ -f "${HOME}/.local/src/google-cloud-sdk/path.zsh.inc" ] && . "${HOME}/.local/src/google-cloud-sdk/path.zsh.inc"
   [ -f "${HOME}/.local/src/google-cloud-sdk/completion.zsh.inc" ] && . "${HOME}/.local/src/google-cloud-sdk/completion.zsh.inc"
fi

if [[ ! -n $TMUX  ]]; then
    bindkey -s '^Qo' '~/.local/bin/tmux_session.sh\n'
fi
