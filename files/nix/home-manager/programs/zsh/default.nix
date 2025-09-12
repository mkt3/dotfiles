{
  pkgs,
  config,
  isGUI,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;

    envExtra = ''
      if [ -z "$BASH_VERSION" ];then
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

      # Pager
      export PAGER=less

      # terminfo
      export TERMINFO="''${XDG_DATA_HOME}/terminfo"
      export TERMINFO_DIRS="''${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
      export COLORTERM="truecolor"

      # zsh session
      export SHELL_SESSIONS_DISABLE=1

      # path env
      if [[ -z "$ZSH_PATH_LOADED" ]]; then
          source "''${HOME}/.config/zsh/path.zsh"
          export ZSH_PATH_LOADED=1
      fi
    ''
    + (if isGUI then "\n# personal env\n. \"\${HOME}/Nextcloud/personal_config/env/zshenv\"" else "");

    initContent = lib.mkBefore ''
      source "''${HOME}/.config/sheldon/sheldon.zsh"

      source "''${ZDOTDIR}/no_defer.zsh"
      zsh-defer source "''${ZDOTDIR}/defer.zsh"
    '';

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 50000;
      save = 50000;
      ignoreAllDups = true;
      ignoreSpace = true;
      ignoreDups = true;
      share = true;
      extended = true;
    };

    shellAliases = {
      wget = "wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\"";
      sudo = "TERM=xterm-256color sudo";
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      history = "history -i";
      wea = "(){ curl -H \"Accept-Language: \${LANG%_*}\" -t-compressed \"wttr.in/\${1:-Tokyo}\" }";
    }
    // (
      if pkgs.stdenv.hostPlatform.isLinux then
        {
          open = "xdg-open";
        }
      else
        { }
    );
  };

  home.file.".local/bin/tmux_session.sh".source = ./tmux_session.sh;

  xdg.configFile = {
    "zsh/no_defer.zsh" = {
      source = ./no_defer.zsh;
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile $HOME/.config/zsh/no_defer.zsh'";
    };
    "zsh/path.zsh" = {
      source = ./path.zsh;
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile $HOME/.config/zsh/path.zsh'";
    };
    "zsh/abbreviations".source = ./abbreviations;

    "zsh/defer.zsh" = {
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile $HOME/.config/zsh/defer.zsh'";
      text = ''
        # rehash
        zstyle ":completion:*:commands" rehash 1

        # terminal title
        echo -ne "\x1b]0;$HOST\x1b\\"

        if [[ ! -n $TMUX  ]]; then
            bindkey -s '^Qo' '~/.local/bin/tmux_session.sh\n'
        fi
      '';
    };

    "sheldon/plugins.toml" = {
      source = ./sheldon/plugins.toml;
      onChange = ''
        ${pkgs.sheldon}/bin/sheldon --config-file=$HOME/.config/sheldon/plugins.toml source > $HOME/.config/sheldon/sheldon.zsh
        ${pkgs.sheldon}/bin/sheldon lock --update
        ${pkgs.zsh}/bin/zsh -c 'zcompile $HOME/.config/sheldon/sheldon.zsh'
      '';
    };
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
}
