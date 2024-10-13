{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;

    dotDir = ".config/zsh";

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

      # less
      export LESS='-g -i -M -R -S -W -x4'

      # Pager
      export PAGER=less

      # Paltform Arch
      export OS=`uname -s`
      export ARCH=`uname -m`
      DISTRO="$OS"
      if [[ "$DISTRO" == "Linux" ]];then
          DISTRO=$(grep -oP '(?<=^NAME=).+' /etc/os-release | tr -d '"')
      fi

      # XDG Base directory
      export XDG_CONFIG_HOME="''${HOME}/.config"
      export XDG_CACHE_HOME="''${HOME}/.cache"
      export XDG_DATA_HOME="''${HOME}/.local/share"
      export XDG_STATE_HOME="''${HOME}/.local/state"

      # zsh
      export ZDOTDIR="''${XDG_CONFIG_HOME}/zsh"
      export ZSH_COMPLETION_DIR="''${XDG_DATA_HOME}/zsh/completion"
      export LISTMAX=1000

      # personal env
      [ -d "''${HOME}/Nextcloud/personal_config/env" ] && . "''${HOME}/Nextcloud/personal_config/env/zshenv"

      # terminfo
      export TERMINFO="''${XDG_DATA_HOME}/terminfo"
      export TERMINFO_DIRS="''${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
      export COLORTERM="truecolor"

      # PATH
      if [[ "$DISTRO" == 'NixOS' ]];then
          export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:''${PATH}"
          export PATH="''${HOME}/.nix-profile/bin:/etc/profiles/per-user/''${USER}/bin:/run/wrappers/bin:''${PATH}"
      elif [[ "$DISTRO" == 'Darwin' ]];then
          MAC_DEFAULT_PATH="/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
          export SHELL_SESSIONS_DISABLE=1

          if [[ "$ARCH" == 'arm64' ]]; then
              export PATH="/opt/homebrew/bin:''${MAC_DEFAULT_PATH}"
          elif [[ "$ARCH" == 'x86_64' ]]; then
               export PATH="/usr/local/bin:''${MAC_DEFAULT_PATH}"
          fi
          # nix
          export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:''${PATH}"
          export PATH="/etc/profiles/per-user/''${USER}/bin:''${PATH}"
          export NIX_PATH="darwin-config=$HOME/.conifg/nix/flake.nix:/nix/var/nix/profiles/per-user/root/channels"
          export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
          export TERMINFO_DIRS="/run/current-system/sw/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:''${TERMINFO_DIRS}"
          export XDG_CONFIG_DIRS=":/run/current-system/sw/etc/xdg:/nix/var/nix/profiles/default/etc/xdg"
          export XDG_DATA_DIRS="/run/current-system/sw/share:/nix/var/nix/profiles/default/share"
          export TERM=$TERM
          export NIX_USER_PROFILE_DIR="/etc/profiles/per-user/''${USER}"
          export NIX_PROFILES="/nix/var/nix/profiles/default /run/current-system/sw"
          # Set up secure multi-user builds: non-root users build through the
          # Nix daemon.
          if [ ! -w /nix/var/nix/db ]; then
               export NIX_REMOTE=daemon
          fi
      else # for linux (except NIXOS)
          LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin"
          export PATH="$LINUX_DEFAULT_PATH"

          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
              . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi
          export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
      fi
      export PATH="''${HOME}/.local/bin:''${PATH}"

      # kubernetes
      export KUBECONFIG="''${XDG_CONFIG_HOME}/kube/config"
      export KUBECACHEDIR="''${XDG_CACHE_HOME}/kube"
    '';

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
        local compiled="''$'1.zwc"

        # Check if the file is in the target directory
        if [[ "''$1" == "''$target_dir/"* ]]; then
          if [[ ! -r "''$compiled" || "''$1" -nt "''$compiled" ]]; then
            echo "\033[1;36mCompiling\033[m ''$1"
            zcompile "''$1"
          fi
        fi
      }

      ensure_zcompiled "''${ZDOTDIR}/.zshrc"

      # sheldon cache technique
      sheldon_cache="''${SHELDON_CONFIG_DIR}/sheldon.zsh"
      sheldon_toml="''${SHELDON_CONFIG_DIR}/plugins.toml"
      if [[ ! -r "''$sheldon_cache" || "''$sheldon_toml" -nt "''$sheldon_cache" ]]; then
          sheldon source > "''$sheldon_cache"
      fi
      source "''$sheldon_cache"
      unset sheldon_cache sheldon_toml

      source "''${ZDOTDIR}/no_defer.zsh"
      zsh-defer source "''${ZDOTDIR}/defer.zsh"
      zsh-defer unfunction source
    '';
  };

  home.file.".local/bin/tmux_session.sh".source = ./tmux_session.sh;

  xdg.configFile = {
    "zsh/no_defer.zsh" = {
      source = ./no_defer.zsh;
      onChange = "rm -rf $HOME/.config/zsh/no_defer.zsh.zwc";
    };
    "zsh/defer.zsh" = {
      source = ./defer.zsh;
      onChange = "rm -rf $HOME/.config/zsh/defer.zsh.zwc";
    };
    "zsh/sheldon/plugins.toml".source = ./sheldon/plugins.toml;
    "zsh/abbreviations".source = ./abbreviations;
  };
}
