# Prompt
autoload -U colors
colors

## Left prompt
if [ -n "${SSH_CONNECTION}" ]; then
    local host_color="cyan"

else
    local host_color="green"
fi

PROMPT="%U%{%(?.${fg[$host_color]}.${fg[red]})%}[%n@%m]%{${reset_color}%}%u(%j) %~
%# "

## Right prompt
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' max-exports 6 # formatに入る変数の最大数
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b@%r' '%c' '%u'
zstyle ':vcs_info:git:*' actionformats '%b@%r|%a' '%c' '%u'
setopt prompt_subst
function _vcs_precmd {
    local st branch color
    STY= LANG=en_US.UTF-8 vcs_info
    st=`git status 2> /dev/null`
    if [[ -z "$st" ]]; then
        RPROMPT=""
        return
    fi
    branch="$vcs_info_msg_0_"
    if   [[ -n "$vcs_info_msg_1_" ]]; then color=${fg[green]} #staged
    elif [[ -n "$vcs_info_msg_2_" ]]; then color=${fg[red]} #unstaged
    elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then color=${fg[blue]} # untracked
    else color=${fg[cyan]}
    fi
    RPROMPT=`echo "%{$color%}($branch)%{$reset_color%}" | sed -e s/@/"%F{yellow}@%f%{$color%}"/`
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
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Alias
setopt complete_aliases

case "${PLATFORM}" in
    osx)
        alias ls="ls -FGh"
        alias ll="ls -l"
        alias la="ls -aF"
        alias sshc="~/.ssh/ssh_change_pokemon.sh"
        ;;
    linux)
        alias ls="ls --color"
        alias ll="ls -l"
        alias la="ls -aF"
        alias open="gnome-open"
        ;;
esac

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias grep='grep --color=auto'
alias x="exit"

cd ()
{
    builtin cd "$@" && ls
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

# Tmux config
export PERCOL=peco

if [[ -n ${SSH_CONNECTION} ]] && [[ ! -n $TMUX && $- == *l* ]] && [[ "TERM" != "dumb" ]]; then
    ID="`tmux list-sessions`"
    if [[ -z "$ID" ]]; then
      tmux new-session
    fi
    create_new_session="Create New Session"
    ID="$ID\n${create_new_session}:"
    ID="`echo $ID | $PERCOL | cut -d: -f1`"
    if [[ "$ID" = "${create_new_session}" ]]; then
       tmux new-session
    elif [[ -n "$ID" ]]; then
       tmux attach-session -t "$ID"
    else
       :  # Start terminal normally
    fi
 fi

# pipenv config
export PIPENV_VENV_IN_PROJECT=true

# direnv config
if type "direnv" > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
