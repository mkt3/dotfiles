{ pkgs, ... }:
{
  home.packages = [ pkgs.karabiner-elements ];

  xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
}
