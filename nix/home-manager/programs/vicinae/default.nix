{
  lib,
  os,
  homeDirectory,
  ...
}:
let
  settings = {
    "$schema" = "https://vicinae.com/schemas/config.json";

    keybinding = "emacs";
    close_on_focus_loss = true;
    pop_to_root_on_close = true;
    escape_key_behavior = "close_window";
    consider_preedit = true;
    encrypt_sensitive_data = true;

    telemetry.system_info = false;

    keybinds.toggle-action-panel = "control+T";

    launcher_window.opacity = 0.98;

    font.normal = {
      size = 12;
      family = "Noto Sans CJK JP";
    };

    theme = {
      light = {
        name = "nord-light";
        icon_theme = "default";
      };
      dark = {
        name = "nord";
      };
    };

    providers = {
      "browser-extension".enabled = false;
      files.enabled = false;
      "raycast-compat".enabled = false;
      theme.enabled = false;
      wm.enabled = false;
      clipboard.preferences = {
        eraseOnStartup = false;
        evictionThreshold = "604800";
        ignorePasswords = true;
        monitoring = true;
        preserveTagged = true;
      };
      power.entrypoints = {
        logout.preferences.confirm = false;
        power-off.preferences.confirm = false;
        reboot.preferences.confirm = false;
        suspend.preferences.confirm = false;
      };
    };
  }
  // lib.optionalAttrs (os == "darwin") {
    providers = {
      clipboard.entrypoints.history.shortcut = "control+Y";
      scripts.preferences.customDirs = [
        "${homeDirectory}/GoogleDrive/local_data_dir/personal_config/wireguard"
      ];
    };
  }
  // lib.optionalAttrs (os != "darwin") {
    theme.dark.icon_theme = "Nordzy-dark";
  };
in
{
  # Home Manager's Vicinae module provides the Linux-only systemd integration.
  programs.vicinae = lib.mkIf (os != "darwin") {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    inherit settings;
  };

  # Vicinae is installed as a Homebrew cask on macOS, where the Home Manager
  # module is unavailable. Render the same settings definition directly.
  xdg.configFile."vicinae/settings.json" = lib.mkIf (os == "darwin") {
    text = builtins.toJSON settings;
  };
}
