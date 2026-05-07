{ pkgs, lib, isDarwin, ... }:
{
  home.packages = lib.optionals (!isDarwin) [
    pkgs.wezterm
    pkgs.libnotify
  ];

  home.file.".local/bin/notify.sh" = {
    source = ./notify.sh;
    executable = true;
  };

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./wezterm.lua;
    "wezterm/ssh.sh".source = ./ssh.sh;
  };
}
