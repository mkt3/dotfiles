{ pkgs, lib, isDarwin, ... }:
{
  home.packages = lib.optionals (!isDarwin) [
    pkgs.wezterm
    pkgs.libnotify
  ];

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./wezterm.lua;
    "wezterm/ssh.sh".source = ./ssh.sh;
  };
}
