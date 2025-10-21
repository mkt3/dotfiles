{ config, pkgs, ... }:
{
  home.packages = [ pkgs.sheldon ];

  home.file.".zshenv".text = ''
    # enhancd
    export ENHANCD_DIR="${config.xdg.dataHome}/enhancd"
  '';
}
