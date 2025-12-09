{
  pkgs,
  config,
  isGUI,
  ...
}:
let
  lib = pkgs.lib;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.patched-emacs;
    extraPackages =
      epkgs:
      [
        epkgs.jinx
        epkgs.treesit-grammars.with-all-grammars
      ]
      ++ lib.optionals isGUI [
        epkgs.pdf-tools
        epkgs.mu4e
      ];
  };

  xdg.desktopEntries = lib.mkIf (isGUI && isLinux) {
    emacs = {
      name = "Emacs";
      genericName = "Text Editor";
      comment = "Edit text";

      exec = "env COLORTERM=truecolor env GTK_IM_MODULE=xim emacs %F";

      icon = "emacs";
      type = "Application";
      terminal = false;
      categories = [
        "Development"
        "TextEditor"
      ];

      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
  };

  xdg.configFile = {
    "emacs/README.org" = {
      source = ./README.org;
      onChange = "rm -rf $HOME/.config/emacs/README.el";
    };
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/init.el".source = ./init.el;
    "emacs/templates".source = ./templates;
    "emacs/ddskk.d/init.el".source = ./ddskk.d/init.el;
    "enchant/en_US.dic" = lib.mkIf isGUI {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Nextcloud/personal_config/enchant/dict/en_US.dic";
    };

    "zsh/defer.zsh" = {
      text = lib.mkMerge (
        [
          ''
            if [[ "$TERM" == "dumb" ]]; then
              unsetopt zle
              unsetopt prompt_cr
              unsetopt prompt_subst
              unfunction precmd
              unfunction preexec
              PS1='$ '
            fi
          ''
        ]
        ++ lib.optionals isDarwin [
          ''
            alias emacs="${config.home.homeDirectory}/Applications/Home\ Manager\ Apps/Emacs.app/Contents/MacOS/Emacs -nw"
          ''
        ]
        ++ lib.optionals isLinux [
          ''
            if [[ -f "/usr/lib/x86_64-linux-gnu/libnss_sss.so.2" ]]; then
              alias emacs="LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_sss.so.2 emacs -nw"
            else
              alias emacs="emacs -nw"
            fi
          ''
        ]
      );
    };
  };

  home.file.".zshenv" = lib.mkIf isGUI {
    text = ''
      # password store
      export PASSWORD_STORE_DIR="${config.home.homeDirectory}/Nextcloud/personal_config/password-store"
    '';
  };

}
