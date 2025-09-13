{ pkgs, ... }:
{
  home.packages = [ pkgs.rofi ];

  xdg.configFile = {
    "rofi/config.rasi".source = ./config.rasi;
    "rofi/scripts".source = ./scripts;
    "rofi/themes".source = ./themes;
  };
}
