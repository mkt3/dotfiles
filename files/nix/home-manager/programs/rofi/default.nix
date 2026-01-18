{ config, pkgs, ... }:
{
  home.packages = [ pkgs.rofi ];

  xdg.configFile = {
    "rofi/config.rasi".text = builtins.replaceStrings [ "~/.config" ] [ config.xdg.configHome ] (
      builtins.readFile ./config.rasi
    );
    "rofi/scripts/bluetooth-ctl.sh" = {
      text = builtins.readFile ./scripts/bluetooth-ctl.sh;
      executable = true;
    };
    "rofi/scripts/system-menu.sh" = {
      text = builtins.readFile ./scripts/system-menu.sh;
      executable = true;
    };
    "rofi/scripts/vpn.sh" = {
      text = builtins.readFile ./scripts/vpn.sh;
      executable = true;
    };
    "rofi/themes".source = ./themes;
  };
}
