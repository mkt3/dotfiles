{ pkgs, ... }:
{
  home.packages = [ pkgs.wezterm ];

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./wezterm.lua;
    "wezterm/ssh.sh".source = ./ssh.sh;
  };
}
