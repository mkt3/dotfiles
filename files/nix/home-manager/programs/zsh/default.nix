{
  pkgs,
  config,
  isGUI,
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

        # Editor (let変数を使用)
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
      source "${config.xdg.configHome}/sheldon/sheldon.zsh"

      source "${config.xdg.configHome}/zsh/no_defer.zsh"
      zsh-defer source "${config.xdg.configHome}/zsh/defer.zsh"
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
      wget = "wget --hsts-file=\"${config.xdg.cacheHome}/wget-hsts\"";
      sudo = "TERM=xterm-256color sudo";
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      history = "history -i";
      wea = "(){ curl -H \"Accept-Language: ${commonLanguage}\" -t-compressed \"wttr.in/\${1:-Tokyo}\" }";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      open = "xdg-open";
    };
  };

  home.file.".local/bin/tmux_session.sh".source = ./tmux_session.sh;

  xdg.configFile = {
    "zsh/no_defer.zsh" = {
      source = ./no_defer.zsh;
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile ${config.xdg.configHome}/zsh/no_defer.zsh'";
    };

    "zsh/path.zsh" = {
      source = ./path.zsh;
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile ${config.xdg.configHome}/zsh/path.zsh'";
    };

    "zsh/abbreviations".source = ./abbreviations;

    "zsh/defer.zsh" = {
      onChange = "${pkgs.zsh}/bin/zsh -c 'zcompile ${config.xdg.configHome}/zsh/defer.zsh'";
      text = ''
        # rehash
        zstyle ":completion:*:commands" rehash 1

        # terminal title
        echo -ne "\x1b]0;$HOST\x1b\\"
      '';
    };

    "sheldon/plugins.toml" = {
      source = ./sheldon/plugins.toml;
      onChange = ''
        ${pkgs.sheldon}/bin/sheldon --config-file=${config.xdg.configHome}/sheldon/plugins.toml source > ${config.xdg.configHome}/sheldon/sheldon.zsh
        ${pkgs.sheldon}/bin/sheldon lock --update
        ${pkgs.zsh}/bin/zsh -c 'zcompile ${config.xdg.configHome}/sheldon/sheldon.zsh'
      '';
    };
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
}
