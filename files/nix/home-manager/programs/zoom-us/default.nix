{ config, pkgs, ... }:
{
  home.packages = [ pkgs.zoom-us ];

  home.file.".zshenv".text = ''
    # zoom
    export SSB_HOME="${config.xdg.dataHome}/zoom"
  '';
}
