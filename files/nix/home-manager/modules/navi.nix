{ pkgs, config, dotfilesDirectory, ... }:
{
  home.packages = [
    pkgs.navi
  ];


  xdg.configFile."navi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/navi";
    recursive = true;
  };
}
