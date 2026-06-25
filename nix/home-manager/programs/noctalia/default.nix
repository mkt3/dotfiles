{
  config,
  noctalia,
  ...
}:
{
  imports = [
    noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      audio = {
        enable_overdrive = true;
      };
      battery = {
        warning_threshold = 15;
      };
      bar.default = {
        margin_edge = 0;
        margin_ends = 0;
        center = [ "active_window" ];
        end = [
          "media"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "clock"
          "tray"
          "control-center"
          "session"
        ];
      };

      brightness = {
        enable_ddcutil = true;
      };

      desktop_widgets = {
        schema_version = 2;
        widget_order = [ ];

        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };

        widget = { };
      };

      location = {
        auto_locate = true;
      };

      shell = {
        avatar_path = "${config.home.homeDirectory}/Nextcloud/Picture/icon/portrait.png";
        font_family = "Noto Sans CJK JP";
        settings_show_advanced = true;
      };

      theme = {
        builtin = "Nord";
        mode = "dark";

        templates = {
          builtin_ids = [ ];
          community_ids = [ ];
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      wallpaper = {
        directory = "${config.home.homeDirectory}/Nextcloud/Picture/wallpaper";

        default = {
          path = "${config.home.homeDirectory}/Nextcloud/Picture/wallpaper/nord.png";
        };

        last = {
          path = "${config.home.homeDirectory}/Nextcloud/Picture/wallpaper/nord.png";
        };
      };
      widget = {
        clock = {
          format = "{:%Y/%m/%d(%a) %H:%M}";
        };
      };
    };
  };
}
