{
  pkgs,
  config,
  dotfilesDirectory,
  ...
}:
{
  home.packages = [ pkgs.rofi-wayland ];

  xdg.configFile."rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/rofi";
    recursive = true;
  };
}
