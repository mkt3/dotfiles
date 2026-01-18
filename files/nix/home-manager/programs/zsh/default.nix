{
  pkgs,
  config,
  isGUI,
  isLinux,
  lib,
  ...
}:
let
  commonLanguage = "en_US.UTF-8";
  commonEditor = "vim";

in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;

    envExtra = lib.mkMerge (
      [
        ''
          export LANGUAGE="${commonLanguage}"
          export LANG="${commonLanguage}"
          export LC_ALL="${commonLanguage}"
          export LC_CTYPE="${commonLanguage}"
        ''

        # Editor
        ''
          export EDITOR=${commonEditor}
          export CVSEDITOR=${commonEditor}
          export SVN_EDITOR=${commonEditor}
          export GIT_EDITOR=${commonEditor}
        ''

        # Pager, Terminfo, Color
        ''
          export LESS='-g -i -M -R -S -W -x4'
          export PAGER=less
          export TERMINFO="${config.xdg.dataHome}/terminfo"
          export TERMINFO_DIRS="${config.xdg.dataHome}/terminfo:/usr/share/terminfo"
          export COLORTERM="truecolor"
        ''

        # Zsh Session, Options, Path Load Logic
        ''
          export SHELL_SESSIONS_DISABLE=1

          if [ -z "$BASH_VERSION" ];then
            setopt no_global_rcs
          fi

          if [[ -z "$ZSH_PATH_LOADED" ]]; then
            source "${config.xdg.configHome}/zsh/path.zsh"
            export ZSH_PATH_LOADED=1
          fi
        ''
      ]
      ++ lib.optionals isGUI [
        ''
          # personal env
          if [ -f "${config.home.homeDirectory}/Nextcloud/personal_config/env/zshenv" ]; then
            source "${config.home.homeDirectory}/Nextcloud/personal_config/env/zshenv"
          fi
        ''
      ]
    );

    initContent = lib.mkBefore ''
       # https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache
       zmodload -F zsh/stat b:zstat 2>/dev/null

       # source command override technique
       function source {
         ensure_zcompiled "$1"
         builtin source "$1"
       }

       function ensure_zcompiled {
         local src="$1"

         src=''${src:a}

         [[ "$src" == "${config.home.homeDirectory}/"* ]] || return 0

         [[ -e "$src" ]] || return 0

         local compiled="$1.zwc"

         local src_mtime compiled_mtime

          zstat -L -A src_stat +mtime "$src" || return 0
         src_mtime=$src_stat[1]

           if [[ -e "$compiled" ]]; then
             zstat -A compiled_stat +mtime "$compiled" || return 0
             compiled_mtime=$compiled_stat[1]
           else
             compiled_mtime=0
         fi

         if (( src_mtime > compiled_mtime )); then
           echo "Compiling $src"
           zcompile "$src"
         fi
       }

       # sheldon cache technique
       sheldon_cache="${config.xdg.configHome}/sheldon/sheldon.zsh"
       sheldon_toml="${config.xdg.configHome}/sheldon/plugins.toml"

       local toml_mtime cache_mtime

       if zstat -L -A toml_stat +mtime "$sheldon_toml"; then
         toml_mtime=$toml_stat[1]
       else
         toml_mtime=0
       fi

       if [[ -r "$sheldon_cache" ]] && zstat -L -A cache_stat +mtime "$sheldon_cache"; then
         cache_mtime=$cache_stat[1]
       else
         cache_mtime=0
       fi

       if (( toml_mtime > cache_mtime )); then
         sheldon source > "$sheldon_cache"
      fi

      source "$sheldon_cache"
      unset sheldon_cache sheldon_toml toml_mtime cache_mtime toml_stat cache_stat

       source "${config.xdg.configHome}/zsh/no_defer.zsh"
       zsh-defer source "${config.xdg.configHome}/zsh/defer.zsh"
       zsh-defer unfunction source
    '';

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 50000;
      save = 50000;
      ignoreAllDups = true;
      findNoDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
      ignorePatterns = [
        "*TOKEN*=* *"
        "*KEY*=* *"
        "*SECRET*=* *"
        "*PASSWORD*=* *"
        "*Authorization:*"
        "*authorization:*"
        "*--token *"
        "*--api-key *"
        "*--password *"
        "ls"
        "ls *"
        "cd"
        "cd *"
        "pwd"
        "exit"
      ];
    };

    shellAliases = {
      wget = "wget --hsts-file=\"${config.xdg.cacheHome}/wget-hsts\"";
      sudo = "TERM=xterm-256color sudo";
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      history = "history -i";
      wea = "(){ curl -H \"Accept-Language: ${commonLanguage}\" -t-compressed \"wttr.in/\${1:-Tokyo}\" }";
    }
    // lib.optionalAttrs isLinux {
      open = "xdg-open";
    };
  };

  home.file.".local/bin/tmux_session.sh" = {
    text = builtins.readFile ./tmux_session.sh;
    executable = true;
  };

  xdg.configFile = {
    "zsh/no_defer.zsh" = {
      source = ./no_defer.zsh;
    };

    "zsh/path.zsh" = {
      source = ./path.zsh;
    };

    "zsh/abbreviations".source = ./abbreviations;

    "zsh/defer.zsh" = {
      text = ''
        # rehash
        zstyle ":completion:*:commands" rehash 1

        # terminal title
        echo -ne "\x1b]0;$HOST\x1b\\"
      '';
    };
    "sheldon/plugins.toml".source = ./plugins.toml;
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [ pkgs.sheldon ];
}
