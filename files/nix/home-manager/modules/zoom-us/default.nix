{ pkgs, ... }:
{
  home.packages = [ pkgs.zoom-us ];

  home.file.".zshenv".text = ''
    # zoom
    export SSB_HOME="''${XDG_DATA_HOME}/zoom"
  '';
}
