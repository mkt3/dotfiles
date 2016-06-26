if ! [ -z $DOTENV_LOADED ]; then
    print 'skip load .zshenv\n'
else
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

    # PATH
    export PATH=/usr/local/bin:$PATH

    setopt no_global_rcs
  
    export DOTENV_LOADED=1
fi

