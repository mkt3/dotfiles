{ config, pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
    hyprcursor = {
      enable = true;
      size = 24;
    };
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.nordzy-icon-theme;
      name = "Nordzy-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "fusion";
    qt5ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/nord.conf";
      icon_theme = "Nordzy-dark";
    };
    qt6ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/nord.conf";
      icon_theme = "Nordzy-dark";
    };
  };

  xdg.configFile = {
    "qt5ct/colors/nord.conf".source = ./qtct-nord.conf;
    "qt6ct/colors/nord.conf".source = ./qtct-nord.conf;
  };
}
