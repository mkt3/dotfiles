# fzf
if [ -n "${commands[fzf]}" ]; then
    eval "$(fzf --zsh)"
fi
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--reverse --border --ansi'

export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --ignore-file=$XDG_CONFIG_HOME/ripgrep/ignore"
export FZF_CTRL_T_OPTS="--preview 'bat  --color=always --style=header,grid --line-range :100 {}'"

export FZF_TMUX_OPTS="-p 80%"

# gpg-agent
if [[ "$OS" == 'Darwin' ]]; then
    if command -v gpgconf > /dev/null && ! pgrep -u "$USER" gpg-agent > /dev/null; then
        gpgconf --launch gpg-agent
    fi
fi

# Tmux
if [[ ! -n $TMUX && $- == *l* && "$TERM" != "dumb" ]]; then
    main_session="main_session"
    tmux_session="`tmux list-sessions 2> /dev/null`"
    if [[ "$tmux_session" =~ "${main_session}" ]]; then
        tmux attach-session -t "$main_session"
    else
        tmux new-session -s "$main_session"
    fi
fi

# Emacs keybind
bindkey -e

# Completion
fpath+=$ZSH_COMPLETION_DIR

# Prompt
autoload -U colors
colors

## Left prompt
if [ -n "${SSH_CONNECTION}" ]; then
    local host_color="cyan"

else
    local host_color="green"
fi

if [[ "$OS" == 'Darwin' ]];then
   OS_FONT=$'\Uf179 '
elif [[ "$OS" == 'Linux' ]];then
   OS_FONT=$'\Uf17c '
fi

USER_FONT=$'\Uf007 '
prompt_common_0="%{%(?.${fg[$host_color]}.${fg[red]})%}[${USER_FONT}%n${OS_FONT}%m]%{${reset_color}%}%u"
prompt_common_1=$'\Uf115 '"%~/"$'\n'"${V_ENV}"

setopt prompt_subst

function _vcs_precmd {
    if [[ "$?" -ne 0 ]]; then
        sed -i -e '$d' "$HISTFILE"
    fi

    V_ENV="$VIRTUAL_ENV:h:t"
    if [[ "$V_ENV" == "." ]]; then
        V_ENV=""
    else
        V_ENV="("$'\Ue606 '"$V_ENV)"
    fi
    prompt_common_1=$'\Uf115 '"%~/"$'\n'"${V_ENV}"
    PROMPT="$prompt_common_0"'$(gitprompt)'"${prompt_common_1}%# "
}

add-zsh-hook precmd _vcs_precmd

function _date_exec {
    prompt_common_1=$'\Uf115 '"%~/"$'\n'"${V_ENV}"
    PROMPT="${prompt_common_0}$(gitprompt)"${prompt_common_1}"[%D{%Y/%m/%d} %*] %# "
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line _date_exec

# Setopt
unsetopt glob_dots
unsetopt ignore_eof
setopt no_flow_control
setopt auto_cd
setopt auto_pushd
setopt no_beep
setopt no_list_beep
#setopt sh_word_split
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


# Command history
# HISTFILE=$XDG_STATE_HOME/zsh/history
# mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|emulate|ls|rm)($| )" ]]
}
