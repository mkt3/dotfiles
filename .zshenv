setopt no_global_rcs

if [ -z $DOTENV_LOADED ]; then
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
        export PATH="/usr/local/bin:$PATH"
    fi
    
    export DOTENV_LOADED=1
fi

