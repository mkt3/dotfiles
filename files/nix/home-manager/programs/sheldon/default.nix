{ pkgs, ... }:
{
  home.packages = [ pkgs.sheldon ];

  home.file.".zshenv".text = ''
    # enhancd
    export ENHANCD_DIR="''${XDG_DATA_HOME}/enhancd"
  '';
}
