setopt no_global_rcs

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

if [[ "$PLATFORM" == 'osx' ]];then
    MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/sbin:/sbin"
    export PATH="/opt/homebrew/bin:/usr/local/bin:$MAC_DEFAULT_PATH"
elif [[ "$PLATFORM" == 'linux' ]];then
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:"
    export PATH="$LINUX_DEFAULT_PATH"
    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/`id $(whoami) | awk -F'[=()]' '{print $2}'`/docker.sock
fi

export PYTHONUSERBASE="$HOME/.local"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
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

# Cargo path
[ -d "$HOME/.cargo" ] && \. "$HOME/.cargo/env"


# nvm path
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
