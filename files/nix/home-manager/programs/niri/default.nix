{ config, pkgs, ... }:

let
  monitors = {
    main    = "LG Electronics LG HDR 4K 0x00035468";
    sub     = "PNP(CEX) CX133 0x00000001";
    builtin = "eDP-1";
  };

  afterNiriUnit = ''
    [Unit]
    After=niri.service
  '';

  afterNiriDropIn = name: {
    "systemd/user/${name}.d/after-niri.conf".text = afterNiriUnit;
  };

  output = {
    criteria,
    position ? null,
    mode,
    scale,
    status ? "enable",
  }: {
    inherit criteria mode scale status;
  } // (if position != null then { inherit position; } else {});

  moveWorkspacesCmd =
    let
      workspaces = [ "main" "chat" "zotero" ];
      move = ws:
        "niri msg action move-workspace-to-monitor --reference \"${ws}\" \"${monitors.main}\"";
    in
      builtins.concatStringsSep "; " (map move workspaces) + ";";

  lockCmd = "${pkgs.swaylock}/bin/swaylock --daemonize";
  displayCmd = status:
    "${pkgs.niri}/bin/niri msg action power-${status}-monitors";

in
{
  xdg.configFile =
    {
      "niri/config.kdl".source = ./config.kdl;
    }
    // afterNiriDropIn "xremap.service"
    // afterNiriDropIn "kanshi.service"
    // afterNiriDropIn "xdg-desktop-portal-wlr.service";

  programs.swaylock = {
  enable = true;

  settings = {
    # base
    color = "3b4252";              # Polar Night
    inside-color = "00000000";
    inside-clear-color = "00000000";
    inside-caps-lock-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";

    # text
    text-color = "d8dee9";         # Snow Storm
    text-clear-color = "e5e9f0";
    text-caps-lock-color = "d08770"; # Aurora orange
    text-ver-color = "81a1c1";     # Frost
    text-wrong-color = "bf616a";   # Aurora red

    # key / backspace highlight
    key-hl-color = "88c0d0";       # Frost cyan
    bs-hl-color = "ebcb8b";        # Aurora yellow
    caps-lock-key-hl-color = "a3be8c"; # Aurora green
    caps-lock-bs-hl-color = "ebcb8b";

    # ring
    ring-color = "81a1c1";          # Frost
    ring-clear-color = "8fbcbb";
    ring-caps-lock-color = "d08770";
    ring-ver-color = "5e81ac";
    ring-wrong-color = "bf616a";

    # line / layout (transparent)
    line-color = "00000000";
    line-clear-color = "00000000";
    line-caps-lock-color = "00000000";
    line-ver-color = "00000000";
    line-wrong-color = "00000000";

    layout-bg-color = "00000000";
    layout-border-color = "00000000";
    layout-text-color = "e5e9f0";

    separator-color = "00000000";

    image = "~/Nextcloud/Picture/wallpaper/nord_lock.png";
  };
  };

  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 590;
        command =
          "${pkgs.libnotify}/bin/notify-send 'Locking in 10 minutes' -t 5000";
      }
      {
        timeout = 600;
        command = lockCmd;
      }
      {
        timeout = 900;
        command = displayCmd "off";
        resumeCommand = displayCmd "on";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = {
      before-sleep = "${displayCmd "off"}; ${lockCmd}";
      after-resume = displayCmd "on";
      lock          = "${displayCmd "off"}; ${lockCmd}";
      unlock        = displayCmd "on";
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile = {
          name = "laptop-only";
          outputs = [
            (output {
              criteria = monitors.builtin;
              mode     = "2944x1840";
              scale    = 1.75;
            })
          ];
        };
      }

      {
        profile = {
          name = "laptop-and-LG";
          outputs = [
            (output {
              criteria = monitors.builtin;
              position = "360,1440";
              mode     = "2944x1840";
              scale    = 1.6;
            })
            (output {
              criteria = monitors.main;
              position = "0,0";
              mode     = "3840x2160";
              scale    = 1.5;
            })
          ];
          exec = moveWorkspacesCmd;
        };
      }

      {
        profile = {
          name = "LG-and-CEX";
          outputs = [
            (output {
              criteria = monitors.main;
              position = "0,0";
              mode     = "3840x2160";
              scale    = 1.5;
            })
            (output {
              criteria = monitors.sub;
              position = "480,1440";
              mode     = "2560x1600";
              scale    = 1.25;
            })
          ];
          exec = moveWorkspacesCmd;
        };
      }
    ];
  };
}
