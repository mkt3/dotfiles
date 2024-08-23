{
  pkgs,
  config,
  homeDirectory,
  dotfilesDirectory,
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

  xdg.configFile."emacs/README.org".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/emacs/README.org";
  xdg.configFile."emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/emacs/early-init.el";
  xdg.configFile."emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/emacs/init.el";
  xdg.configFile."emacs/templates".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/emacs/templates";
  xdg.configFile."emacs/ddskk.d/init.el".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/emacs/ddskk.d/init.el";

  xdg.configFile."enchant/en_US.dic" = lib.mkIf (isGUI) {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/Nextcloud/personal_config/enchant/dict/en_US.dic";
  };
}
