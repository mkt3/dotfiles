{ pkgs, ... }:
{
  home.packages = [ pkgs.navi ];

  xdg.configFile = {
    "navi/config.yaml".source = ./config.yaml;
    "navi/cheats".source = ./cheats;
  };
}
