{ config, pkgs, ... }:
{
  home.packages = [ pkgs.dvdplusrwtools ];

  home.file.".zshenv".text = ''
    # dvdcss
    export DVDCSS_CACHE="${config.xdg.dataHome}/dvdcss"
  '';
}
