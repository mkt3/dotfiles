{ pkgs, ... }:
{
  home.packages = [
    (import ../../packages/aerospace { inherit pkgs; })
  ];

  xdg.configFile."aerospace/aerospace.toml".source = ./aerospace.toml;
}
