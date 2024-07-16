{ pkgs, isGUI, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  lib = pkgs.lib;
in
{
  home.pointerCursor = lib.mkIf (isLinux && isGUI) {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk = lib.mkIf (isLinux && isGUI) {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.papirus-nord;
      name = "Papirus-Dark";
    };
  };
}
