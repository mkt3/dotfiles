{
  config,
  lib,
  pkgs,
  ...
}:
let
  networkPlugin =
    builtins.replaceStrings
      [
        "@PATH@"
        "@WG_BIN@"
      ]
      [
        (lib.makeBinPath [
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.gnused
          pkgs.wireguard-tools
        ])
        "/etc/profiles/per-user/${config.home.username}/bin/wg"
      ]
      (builtins.readFile ./plugins/network.sh);
in
{
  programs.sketchybar = {
    enable = true;
    config = {
      text = builtins.replaceStrings [ "~/.config" ] [ config.xdg.configHome ] (
        builtins.readFile ./sketchybarrc
      );
    };
  };

  xdg.configFile."sketchybar/colors.sh" = {
    text = builtins.readFile ./colors.sh;
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
    text = networkPlugin;
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

  xdg.configFile."sketchybar/items/workspaces.sh" = {
    text = builtins.readFile ./items/workspaces.sh;
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/omniwm/start.sh" = {
    text = builtins.readFile ./plugins/omniwm/start.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/omniwm/watch.sh" = {
    text = builtins.readFile ./plugins/omniwm/watch.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/omniwm/refresh.sh" = {
    text = builtins.readFile ./plugins/omniwm/refresh.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/omniwm/click.sh" = {
    text = builtins.readFile ./plugins/omniwm/click.sh;
    executable = true;
  };
}
