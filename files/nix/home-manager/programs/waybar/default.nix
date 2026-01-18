{ pkgs, config, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 0;
        modules-left = [
          "niri/workspaces"
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "custom/vpn"
          "cpu"
          "memory"
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "tray"
          "idle_inhibitor"
        ];

        "niri/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "main" = "";
            "second" = "";
            "emacs" = "";
            "chat" = "";
            "game" = "";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };
        # "hyprland/workspaces" = {
        #   "format" = "{name} {icon}";
        #   "format-icons" = {
        #     "1: main" = "";
        #     "9: sub" = "";
        #     "2: slack" = "";
        #     "8: game" = "";
        #     "10: media" = "";
        #     "urgent" = "";
        #     "active" = "";
        #     "default" = "";
        #   };
        # };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          "icon-size" = 20;
          "spacing" = 2;
        };
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format" = "{:%Y-%m-%d(%a) %H:%M}";
          "format-alt" = "{:%Y-%m-%d(%a) %H:%M}";
        };
        "cpu" = {
          "format" = "  {usage}% LA:{load}";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "  {used:0.1f}G/{total:0.1f}G({percentage}%)";
        };
        "backlight" = {
          "format" = "{icon}  {percent}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery" = {
          "states" = {
            "full" = 100;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon}  {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-full" = "";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "pulseaudio" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-bluetooth" = "  {icon} {volume}% {format_source}";
          "format-bluetooth-muted" = "  󰝟  {format_source}";
          "format-muted" = "󰝟  {format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = " ";
          "format-icons" = {
            "headphone" = " ";
            "hands-free" = " ";
            "headset" = " ";
            "phone" = " ";
            "portable" = " ";
            "car" = " ";
            "default" = [
              " "
              " "
              " "
            ];
          };
          "on-click" = "pwvucontrol";
        };
        "custom/vpn" = {
          "format" = "  {}";
          "interval" = 5;
          "exec" = "${config.home.homeDirectory}/.config/waybar/scripts/nm-vpn.sh";
          "exec-if" = "exit 0";
        };
      };
    };
    style = ''
      /* ---------------------------------------------------------
       * styles
       * ------------------------------------------------------ */

      /* COLORS */

      /* Nord */
      @define-color bg #2E3440;

      @define-color warning #ebcb8b;
      @define-color critical #BF616A;
      @define-color workspacesfocused #4C566A;
      @define-color tray @workspacesfocused;
      @define-color nord_bg #434C5E;
      @define-color nord_light #D8DEE9;
      @define-color nord_dark_font #434C5E;

      /* Reset all styles */
      * {
          border: none;
          border-radius: 3px;
          min-height: 0;
          margin: 0.10em 0.2em;
      }


      /* The whole bar */
      #waybar {
          background: @bg;
          color: @nord_light;
          font-family: Noto Sans CJK JP, Hack Nerd Font, sans-serif;
          font-size: 14px;
      }


      /* Each module */
      #clock,
      #mode,
      #custom-pacman,
      #pulseaudio,
      #battery,
      #backlight {
          padding-left: 0.6em;
          padding-right: 0.6em;
      }


      /* Each critical module */
      #memory.critical,
      #cpu.critical,
      #temperature.critical,
      #battery.critical {
          color: @critical;
      }

      /* Each warning */
      #memory.warning,
      #cpu.warning,
      #temperature.warning,
      #battery.warning {
          background: @warning;
          color: @nord_dark_font;
      }

      /* And now modules themselves in their respective order */

      #mode { /* Shown current Sway mode (resize etc.) */
          color: @nord_light;
          background: @nord_bg;
      }

      /* Workspaces stuff */
      #workspaces button {
          font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
          padding: 0;
         /*color: #999;*/
          color: #D8DEE9;
          opacity: 0.3;
          background: none;
          font-size: 1em;
      }

      #workspaces button.focused {
          background: @workspacesfocused;
          color: #D8DEE9;
          opacity: 1;
          padding: 0 0.4em;
      }

      #workspaces button.urgent {
          border-color: #c9545d;
          color: #c9545d;
          opacity: 1;
      }

      #window {
          margin-right: 40px;
          margin-left: 40px;
          font-weight: normal;
      }

      /* right module default */
      #cpu,
      #memory,
      #pulseaudio,
      #battery,
      #backlight,
      #clock,
      #tray,
      #custom-pacman {
          color: @nord_light;
          background: @nord_bg;
      }

      #idle_inhibitor {
          background: @bg;
          padding: 0 0.6em;
      }

      #cpu {
          padding-left: 0.6em;
          padding-right: 0.6em;
          margin-right: 0;
          border-radius: 0;

      }
      #memory {
          padding-left: 0;
          margin-left:0;
          padding-right: 0.6em;
          border-radius: 0;
      }

      #tray {
          padding: 0;
          margin: 0;
          background: @bg;
      }
    '';
  };
  xdg.configFile."waybar/scripts/nm-vpn.sh" = {
    text = ''
      #!/usr/bin/env sh
      nmcli -t connection show --active | awk -F ':' '
      $3=="wireguard" {
          name=$1
          status="ON"
      }
      $3=="vpn" {
          name=$1
          status="ON"
      }
      END {if(status) printf("%s", name)}'
    '';
  };
}
