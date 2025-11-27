{ config, pkgs, ... }:
{
  home.packages =
    if pkgs.stdenv.hostPlatform.isDarwin then
      [ pkgs.brewCasks.zoom ]
    else
      [ pkgs.zoom-us ];

  home.file.".zshenv".text = ''
    # zoom
    export SSB_HOME="${config.xdg.dataHome}/zoom"
  '';
}
