{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.dvdplusrwtools ];

  programs.zsh.envExtra = lib.mkAfter ''
    # dvdcss
    export DVDCSS_CACHE="${config.xdg.dataHome}/dvdcss"
  '';
}
