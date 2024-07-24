{ pkgs, config, dotfilesDirectory, ... }:
{
  home.packages = [
    pkgs.navi
  ];


  home.file.".config/navi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${dotfilesDirectory}/files/navi";
    recursive = true;
  };
}
