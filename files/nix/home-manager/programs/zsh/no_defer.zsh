# gpg-agent
if [[ "$OS" == 'Darwin' ]]; then
    if command -v gpgconf > /dev/null && ! pgrep -u "$USER" gpg-agent > /dev/null; then
        gpgconf --launch gpg-agent
    fi
fi

# Tmux
if [[ ! -n $TMUX ]]; then
    bindkey -s '^Qo' '~/.local/bin/tmux_session.sh\n'
fi

if [[ ! -n $TMUX && $- == *l* && "$TERM" != "dumb" ]]; then
    main_session="main_session"
    tmux attach-session -t "$main_session" || tmux new-session -s "$main_session"
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

function format_duration() {
    local total_seconds=$1
    local hours=$(( total_seconds / 3600 ))
    local minutes=$(( (total_seconds % 3600) / 60 ))
    local seconds=$(( total_seconds % 60 ))

    if (( hours > 0 )); then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif (( minutes > 0 )); then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}

function _time_and_date_precmd() {
    local TIMER_END=$SECONDS
    local LAST_CMD_DURATION=$(( TIMER_END - TIMER_START ))
    local CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

    if [[ -n "$TIMER_START" && "$LAST_CMD_DURATION" -gt 300 ]]; then
        local formatted_duration=$(format_duration $LAST_CMD_DURATION)
        printf "\nCommand finished at %s, took %s\n" "$CURRENT_TIME" "$formatted_duration"
    fi

    TIMER_START=""
}

function _time_and_date_preexec() {
    TIMER_START=$SECONDS
}

add-zsh-hook preexec _time_and_date_preexec
add-zsh-hook precmd _time_and_date_precmd

# Setopt
unsetopt glob_dots
unsetopt ignore_eof
setopt no_flow_control
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
setopt complete_aliases
setopt EXTENDED_GLOB
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
