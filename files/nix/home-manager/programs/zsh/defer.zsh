# mise
(( ${+commands[mise]} )) && eval "$(mise activate zsh)"

# direnv
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

# rehash
zstyle ":completion:*:commands" rehash 1

# comment
setopt INTERACTIVE_COMMENTS

# terminal title
echo -ne "\x1b]0;$HOST\x1b\\"

# Alias
setopt complete_aliases

case "${OS}" in
    Darwin)
        alias emacs='${HOME}/Applications/Home\ Manager\ Apps/Emacs.app/Contents/MacOS/Emacs -nw'
        ;;
    Linux)
        alias open="xdg-open"
        alias emacs="emacs -nw"
        ;;
esac

alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias sudo='TERM=xterm-256color sudo'
alias grep="grep --color=auto"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias history="history -i"

# Ls colors
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors "${LS_COLORS}"

if type lsd > /dev/null 2>&1; then
    alias ls='lsd -F'
else
    alias ls='ls --color=auto'
fi

chpwd() {
    lsd -F
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

# for delta bat completion
compdef _gnu_generic bat delta

# zoxide
eval "$(zoxide init zsh --cmd j)"

function sd()
{
    local session_name="$(tmux display-message -p '#S')"
    if [ -z "$session_name" ]; then
        cd "$HOME"
    fi

    local default_dir
    if [ "$session_name" = "main_session" ]; then
        default_dir="$HOME"
    else
        default_dir="$(ghq list --exact --full-path "$session_name")"
    fi

    cd "$default_dir"
}

if [[ ! -n $TMUX  ]]; then
    bindkey -s '^Qo' '~/.local/bin/tmux_session.sh\n'
fi

# Remove only the files that have been deleted more than 7 days ago:
yes y | trash-empty 7

# Mount Google Drive (Arch Linux desktop environment only)
local GOOGLE_DRIVE="${HOME}/GoogleDrive"
if [ -x "$(command -v google-drive-ocamlfuse)" ] && ! mountpoint -q "$GOOGLE_DRIVE"; then
    google-drive-ocamlfuse "$GOOGLE_DRIVE"
fi

# for kubectl
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
