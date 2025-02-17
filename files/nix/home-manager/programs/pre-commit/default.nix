{ pkgs, config, ... }:
{
  home.packages = [ pkgs.pre-commit ];

  programs.git = {
    extraConfig = {
      init = {
        templatedir = "${config.home.homeDirectory}/.config/git/git-templates/pre-commit";
      };
    };
  };

  xdg.configFile."git/git-templates/pre-commit" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home-manager/programs/pre-commit/git-templates/pre-commit";
    recursive = true;
  };

}
