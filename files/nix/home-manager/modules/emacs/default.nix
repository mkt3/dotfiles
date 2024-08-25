{
  pkgs,
  config,
  homeDirectory,
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
    extraPackages = epkgs: [
      epkgs.pdf-tools
      epkgs.mu4e
      epkgs.jinx
      epkgs.treesit-grammars.with-all-grammars
    ];
  };

  xdg.configFile = {
    "emacs/README.org".source = ./README.org;
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/init.el".source = ./init.el;
    "emacs/templates".source = ./templates;
    "emacs/ddskk.d/init.el".source = ./ddskk.d/init.el;
    "enchant/en_US.dic" = lib.mkIf (isGUI) {
      source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/Nextcloud/personal_config/enchant/dict/en_US.dic";
    };
  };
}
