if [[ $SETUP == "TRUE" ]];then
    echo "loading from setup script"
else
    setopt no_global_rcs
fi

# Language
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# Editor
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Pager
export PAGER=less

# Paltform Arch
export OS=`uname -s`
export ARCH=`uname -m`

if [[ "$OS" == 'Darwin' ]];then
    PLATFORM='osx'
elif [[ "$OS" == 'Linux' ]];then
    PLATFORM='linux'
fi

export PLATFORM

# PATH
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# zsh
ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ "$PLATFORM" == 'osx' ]];then
    MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/sbin:/sbin"
    export PATH="/opt/homebrew/bin:/usr/local/bin:$MAC_DEFAULT_PATH"
    export SHELL_SESSIONS_DISABLE=1
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"

elif [[ "$PLATFORM" == 'linux' ]];then
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:"
    export PATH="$LINUX_DEFAULT_PATH"
    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/`id $(whoami) | awk -F'[=()]' '{print $2}'`/docker.sock
fi

export PYTHONUSERBASE="$HOME/.local"

# Pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[ -d $PYENV_ROOT ] && eval "$(pyenv init --path)"
[ -d $PYENV_ROOT ] && eval "$(pyenv init -)"

# Poety path
export PATH="$HOME/.poetry/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export PYTHONDONTWRITEBYTECODE=1

# Jupyter path
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_DATA_DIR="$HOME/.local/share/jupyter"

# RUSTUP & Cargo path
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
[ -d "$CARGO_HOME" ] && \. "$CARGO_HOME/env"

# nvm path
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# npm path
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# cuda path
if [[ "$PLATFORM" == 'linux' ]];then
    export PATH="$PATH:/opt/cuda/bin:/usr/local/cuda-11.3/bin"
fi

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# vim
export VIMINIT="set nocp | source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"

# enhancd
export ENHANCD_DIR="$XDG_DATA_HOME/enhancd"

# terminfo
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# go
export GOPATH="${XDG_DATA_HOME}/go"
export PATH="$PATH:$(go env GOPATH)/bin"
