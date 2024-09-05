{ pkgs, ... }:
{
  home.packages = [ pkgs.dvdplusrwtools ];

  home.file.".zshenv".text = ''
    # dvdcss
    export DVDCSS_CACHE="''${XDG_DATA_HOME}/dvdcss"
  '';
}
