{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk = {
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
