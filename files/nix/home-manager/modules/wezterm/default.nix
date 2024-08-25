{ pkgs, ... }:
{
  home.packages = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) [ pkgs.wezterm ];

  xdg.configFile = {
    "wezterm/wezterm.lua".source = ./wezterm.lua;
    "wezterm/ssh.sh".source = ./ssh.sh;
  };
}
