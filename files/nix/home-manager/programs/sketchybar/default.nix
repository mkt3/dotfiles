{ config, pkgs, ... }:
{
  home.packages = [ pkgs.sketchybar ];

  xdg.configFile."sketchybar/sketchybarrc" = {
    text = builtins.replaceStrings [ "~/.config" ] [ config.xdg.configHome ] (
      builtins.readFile ./sketchybarrc
    );
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/aerospace.sh" = {
    text = builtins.readFile ./plugins/aerospace.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/battery.sh" = {
    text = builtins.readFile ./plugins/battery.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/clock.sh" = {
    text = builtins.readFile ./plugins/clock.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/front_app.sh" = {
    text = builtins.readFile ./plugins/front_app.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/network.sh" = {
    text = builtins.readFile ./plugins/network.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/org-task.sh" = {
    text = builtins.readFile ./plugins/org-task.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/space.sh" = {
    text = builtins.readFile ./plugins/space.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/volume.sh" = {
    text = builtins.readFile ./plugins/volume.sh;
    executable = true;
  };
}
