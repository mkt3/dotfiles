{ config, pkgs, ... }:
let
  omniwm = pkgs.callPackage ../../packages/omniwm { };
  dotfilesDir = "${config.home.homeDirectory}/workspace/ghq/github.com/mkt3/dotfiles";
in
{
  home.packages = [ omniwm ];

  xdg.configFile."omniwm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nix/home-manager/programs/omniwm/config";
    force = true;
  };
}
