{
  config,
  ...
}:

let
  monitors = {
    main = "LG Electronics LG HDR 4K 0x00035468";
    sub = "PNP(CEX) CX133 0x00000001";
    builtin = "eDP-1";
  };

  afterNiriUnit = ''
    [Unit]
    After=niri.service
  '';

  afterNiriDropIn = name: {
    "systemd/user/${name}.d/after-niri.conf".text = afterNiriUnit;
  };

  output =
    {
      criteria,
      position ? null,
      mode,
      scale,
      status ? "enable",
    }:
    {
      inherit
        criteria
        mode
        scale
        status
        ;
    }
    // (if position != null then { inherit position; } else { });

  moveWorkspacesCmd =
    let
      workspaces = [
        "main"
        "chat"
        "zotero"
      ];
      move = ws: "niri msg action move-workspace-to-monitor --reference \"${ws}\" \"${monitors.main}\"";
    in
    builtins.concatStringsSep "; " (map move workspaces) + ";";

in
{
  xdg.configFile = {
    "niri/config.kdl".source = ./config.kdl;
  }
  // afterNiriDropIn "xremap.service"
  // afterNiriDropIn "kanshi.service"
  // afterNiriDropIn "xdg-desktop-portal-wlr.service";

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
              mode = "2944x1840";
              scale = 1.75;
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
              mode = "2944x1840";
              scale = 1.6;
            })
            (output {
              criteria = monitors.main;
              position = "0,0";
              mode = "3840x2160";
              scale = 1.5;
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
              mode = "3840x2160";
              scale = 1.5;
            })
            (output {
              criteria = monitors.sub;
              position = "480,1440";
              mode = "2560x1600";
              scale = 1.25;
            })
          ];
          exec = moveWorkspacesCmd;
        };
      }
    ];
  };
}
