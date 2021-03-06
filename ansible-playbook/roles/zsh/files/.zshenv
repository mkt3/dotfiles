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
export XDG_CONFIG_HOME=~/.config

if [[ "$PLATFORM" == 'osx' ]];then
    MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/sbin:/sbin"
    export PATH="/opt/homebrew/bin:/usr/local/bin:$MAC_DEFAULT_PATH"
elif [[ "$PLATFORM" == 'linux' ]];then
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:"
    export PATH="$LINUX_DEFAULT_PATH"
fi

export PYTHONUSERBASE="$HOME/.local"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"

export PATH="$HOME/.poetry/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export PYTHONDONTWRITEBYTECODE=1

# Cargo path
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
