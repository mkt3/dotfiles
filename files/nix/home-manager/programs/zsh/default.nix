{
  pkgs,
  config,
  isGUI,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    dotDir = ".config/zsh";
    autocd = true;

    envExtra =
      ''
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

        # less
        export LESS='-g -i -M -R -S -W -x4'

        # Pager
        export PAGER=less

        # terminfo
        export TERMINFO="''${XDG_DATA_HOME}/terminfo"
        export TERMINFO_DIRS="''${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
        export COLORTERM="truecolor"

        # path env
        if [[ -z "$ZSH_PATH_LOADED" ]]; then
            source "''${HOME}/.config/zsh/path.zsh"
            export ZSH_PATH_LOADED=1
        fi
      ''
      + (if isGUI then "\n# personal env\n. \"\${HOME}/Nextcloud/personal_config/env/zshenv\"" else "");

    initExtraFirst = ''
      # https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache

      # Override the source command
      function source {
        ensure_zcompiled "''$1"
        builtin source "''$1"
      }

      # Function to compile only files in ~/.config/zsh
      function ensure_zcompiled {
        local target_dir="''$HOME/.config/zsh"
        local compiled="''$1.zwc"

        # Check if the file is in the target directory
        if [[ "''$1" == "''$target_dir/"* ]]; then
          if [[ ! -r "''$compiled" || "''$1" -nt "''$compiled" ]]; then
            echo "\033[1;36mCompiling\033[m ''$1"
            zcompile "''$1" "''$compiled"
          fi
        fi
      }

      ensure_zcompiled "''${ZDOTDIR}/.zshrc"

      # sheldon cache technique
      sheldon_cache="''${SHELDON_CONFIG_DIR}/sheldon.zsh"
      sheldon_toml="''${SHELDON_CONFIG_DIR}/plugins.toml"
      if [[ ! -r "''$sheldon_cache" || "''$sheldon_toml" -nt "''$sheldon_cache" ]]; then
        sheldon lock --update
        sheldon source > "''$sheldon_cache"
      fi
      source "''$sheldon_cache"
      unset sheldon_cache sheldon_toml

      source "''${ZDOTDIR}/no_defer.zsh"
      zsh-defer source "''${ZDOTDIR}/defer.zsh"
      zsh-defer unfunction source
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

    shellAliases =
      {
        wget = "wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\"";
        sudo = "TERM=xterm-256color sudo";
        grep = "grep --color=auto";
        cp = "cp -i";
        mv = "mv -i";
        history = "history -i";
      }
      // (
        if pkgs.stdenv.isLinux then
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
      onChange = "rm -rf $HOME/.config/zsh/no_defer.zsh.zwc";
    };
    "zsh/path.zsh" = {
      source = ./path.zsh;
      onChange = "rm -rf $HOME/.config/zsh/path.zsh.zwc";
    };
    "zsh/sheldon/plugins.toml" = {
      source = ./sheldon/plugins.toml;
      onChange = "rm -rf $HOME/.config/zsh/sheldon/sheldon.zs*";
    };
    "zsh/abbreviations".source = ./abbreviations;
  };

  xdg.configFile."zsh/defer.zsh" = {
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

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
}
