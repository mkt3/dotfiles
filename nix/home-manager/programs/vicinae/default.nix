{
  config,
  vicinae,
  vicinae-extensions,
  lib,
  username,
  pkgs,
  ...
}:
{
  imports = [
    vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";

      keybinding = "emacs";

      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;

      keybinds = {
        toggle-action-panel = "control+T";
      };

      telemetry = {
		    system_info = false;
	    };

      font = {
        normal = {
          size = 12;
          family = "Noto Sans CJK JP";
        };
      };

      theme = {
        light = {
          name = "nord-light";
          icon_theme = "default";
        };
        dark = {
          name = "nord";
          icon_theme = "Nordzy-dark";
        };
      };
      launcher_window = {
        opacity = 0.98;
      };

      providers = {
        clipboard = {
          preferences = {
            encryption = false;
            eraseOnStartup = true;
            ignorePasswords = true;
            monitoring = true;
          };
        };

        power = {
          entrypoints = {
            logout.preferences.confirm = false;
            power-off.preferences.confirm = false;
            reboot.preferences.confirm = false;
            suspend.preferences.confirm = false;
          };
        };
      };
    };
    extensions = with vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      chromium-bookmarks
      nix
      power-profile
    ];
  };
}
