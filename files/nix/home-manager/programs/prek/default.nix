{ pkgs, config, ... }:
{
  home.packages = [ pkgs.prek ];

  programs.git = {
    settings = {
      init = {
        templatedir = "${config.home.homeDirectory}/.config/git/git-templates/pre-commit";
      };
    };
  };

  xdg.configFile."git/git-templates/pre-commit" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home-manager/programs/prek/git-templates/pre-commit";
    recursive = true;
  };

}
