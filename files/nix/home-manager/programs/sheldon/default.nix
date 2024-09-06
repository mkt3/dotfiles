{ pkgs, ... }:
{
  home.packages = [ pkgs.sheldon ];

  home.file.".zshenv".text = ''
    # sheldon
    export SHELDON_CONFIG_DIR="$ZDOTDIR/sheldon"
    export SHELDON_DATA_DIR="$XDG_DATA_HOME/sheldon"

    # enhancd
    export ENHANCD_DIR="''${XDG_DATA_HOME}/enhancd"


  '';

}
