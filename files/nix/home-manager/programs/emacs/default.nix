{
  pkgs,
  config,
  isGUI,
  ...
}:
let
  lib = pkgs.lib;
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
      ++ (
        if isGUI then
          [
            epkgs.pdf-tools
            epkgs.mu4e
          ]
        else
          [ ]
      );
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
  };

  home.file.".zshenv" = lib.mkIf isGUI {
    text = ''
      # password store
      export PASSWORD_STORE_DIR="''${HOME}/Nextcloud/personal_config/password-store"
    '';
  };
}
