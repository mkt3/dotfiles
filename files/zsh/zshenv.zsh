if [ -n "$BASH_VERSION" ];then
    echo "Loading zshenv from setup script"
else
    setopt no_global_rcs
fi

# Language
export LANGUAGE="en_US.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

# Editor
export EDITOR=vim
export CVSEDITOR="$EDITOR"
export SVN_EDITOR="$EDITOR"
export GIT_EDITOR="$EDITOR"

# less
export LESS='-g -i -M -R -S -W -x4'

# Pager
export PAGER=less

# Paltform Arch
export OS=`uname -s`
export ARCH=`uname -m`

# XDG Base directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZSH_COMPLETION_DIR="${XDG_DATA_HOME}/zsh/completion"
export LISTMAX=1000

# personal env
[ -d "${HOME}/Nextcloud/personal_config/env" ] && . "${HOME}/Nextcloud/personal_config/env/zshenv"

# sheldon
export SHELDON_CONFIG_DIR="$ZDOTDIR/sheldon"

# password store
[ -d "${HOME}/Nextcloud/personal_config/password-store" ] && export PASSWORD_STORE_DIR="${HOME}/Nextcloud/personal_config/password-store"

# PATH
if [[ "$OS" == 'Darwin' ]];then
    MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
    export SHELL_SESSIONS_DISABLE=1

    export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/homebrew/Brewfile"

    if [[ "$ARCH" == 'arm64' ]]; then
        export PATH="/opt/homebrew/bin:${MAC_DEFAULT_PATH}"
        export PATH="/opt/homebrew/opt/texinfo/bin:${PATH}"
    elif [[ "$ARCH" == 'x86_64' ]]; then
        export PATH="/usr/local/bin:${MAC_DEFAULT_PATH}"
        export PATH="/usr/local/opt/texinfo/bin:${PATH}"
    fi
    export PATH="${HOME}/.local/src/emacs/nextstep/Emacs.app/Contents/MacOS/bin:${PATH}"
    export PATH="${PATH}:/Applications/recoll.app/Contents/MacOS"
elif [[ "$OS" == 'Linux' ]];then
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:"
    export PATH="$LINUX_DEFAULT_PATH"
    # Rootless docker path
    export DOCKER_HOST=unix:///run/user/`id $(whoami) | awk -F'[=()]' '{print $2}'`/docker.sock
fi
export PATH="${HOME}/.local/bin:${PATH}"

# Python
export PYTHONUSERBASE="${HOME}/.local"
export PYTHONDONTWRITEBYTECODE=1

# Pipx path
export PIPX_HOME="${HOME}/.local/share/pipx"

# ipython path
export IPYTHONDIR="${XDG_CONFIG_HOME}/jupyter"

# Jupyter path
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
export JUPYTER_DATA_DIR="${XDG_DATA_HOME}/jupyter"

# RUSTUP & Cargo path
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
[ -d "$CARGO_HOME" ] && . "${CARGO_HOME}/env"

# node path
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PATH="${PATH}:${XDG_DATA_HOME}/npm/bin"

# cuda path
if [[ "$OS" == 'Linux' ]];then
    export PATH="${PATH}:/opt/cuda/bin:/usr/local/cuda-11.3/bin"
    export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
fi

# docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# vim
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# enhancd
export ENHANCD_DIR="${XDG_DATA_HOME}/enhancd"

# terminfo
export TERMINFO="${XDG_DATA_HOME}/terminfo"
export TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
export COLORTERM="truecolor"

# go
export GOPATH="${XDG_DATA_HOME}/go"
export PATH="$PATH:${GOPATH}/bin"

# navi
export NAVI_CONFIG="${HOME}/.config/navi/config.yaml"

# latex
export PATH="${PATH}:/Library/TeX/texbin"

# GnuPG
## default value is ~/.gnupg.  If use non-default GnuPG Home directory, need to edit all socket files.
export GNUPGHOME="${HOME}/.gnupg"
export GPG_TTY=$(tty)

# ssh
export SSH_AGENT_PID=""
if [[ "$OS" == 'Linux' ]];then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
elif [[ "$OS" == 'Darwin' ]];then
    export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
fi

# zoom
export SSB_HOME="${XDG_DATA_HOME}/zoom"

# gtk2
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"

# mu
export XAPIAN_CJK_NGRAM=1

# sqlite
export SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history"

# dvdcss
export DVDCSS_CACHE="${XDG_DATA_HOME}/dvdcss"

# opam
export OPAMROOT="${XDG_DATA_HOME}/opam"
export PATH="${PATH}:${OPAMROOT}/default/bin:"

# zoxide
export _ZO_DATA_DIR=$XDG_DATA_HOME

# mise
export MISE_CONFIG_FILE="${XDG_CONFIG_HOME}/mise/config.toml"
export MISE_DATA_DIR="${XDG_DATA_HOME}/mise"
export MISE_CACHE_DIR="${XDG_CACHE_HOME}/mise"
export MISE_USE_TOML=1

# recoll
export RECOLL_CONFDIR="${XDG_CONFIG_HOME}/recoll"

# kubernetes
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config" 
export KUBECACHEDIR="${XDG_CACHE_HOME}/kube"
