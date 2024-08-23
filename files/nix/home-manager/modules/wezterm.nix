{
  pkgs,
  config,
  dotfilesDirectory,
  ...
}:
{
  home.packages = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) [ pkgs.wezterm ];

  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/files/wezterm";
    recursive = true;
  };
}
