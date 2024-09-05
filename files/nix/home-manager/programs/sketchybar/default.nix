{ pkgs, ... }:
{
  home.packages = [ pkgs.sketchybar ];

  xdg.configFile."sketchybar/sketchybarrc" = {
    source = ./sketchybarrc;
    executable = true;
  };

  xdg.configFile."sketchybar/plugins".source = ./plugins;
}
