{ config, pkgs, ... }:
{
  xdg.configFile."systemd/user/xremap.service.d/after-niri.conf".text = ''
      [Unit]
      After=niri.service
    '';

   xdg.configFile."systemd/user/xdg-desktop-portal-wlr.service.d/after-niri.conf".text = ''
      [Unit]
      After=niri.service
    '';

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 300                                # 5min.
        on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r                 # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
    listener {
        timeout = 300                                          # 5min.
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
        on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
    }

    listener {
        timeout = 600                                 # 10min
        on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }

    listener {
        timeout = 630                                 # 10.5min
        on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
        on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 1800                                # 30min
        on-timeout = systemctl suspend                # suspend pc
    }
  '';

  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
      ignore_empty_input = true
    }

    background {
      monitor =
      blur_passes = 0
      blur_size = 7
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    label {
      monitor =
      text = $TIME
      font_size = 175
      position = 0, 325
      halign = center
      valing = top
    }

    input-field {
      monitor =
      size = 200, 30
      outline_thickness = 3
      dots_size = 0.15
      dots_spacing = 0.25
      dots_center = false
      dots_rounding = -1
      rounding = -1
      inner_color = rgb(175, 175, 175)
      placeholder_text = $USER
      position = 0, 100
      halign = center
      valign = bottom
      check_color = rgb(94, 213, 45)
      fail_color = rgb(191, 354, 0)
      fail_text = <span color="white">Failed $ATTEMPTS times</span>
      hide_input = false
    }
  '';

  home.file.".zshenv".text = ''
    # icons
    export XCURSOR_PATH=/usr/share/icons:"${config.xdg.dataHome}/icons"
  '';

  # services.kanshi = {
#     enable = true;
#     systemdTarget = "hyprland-session.target";

#     settings = [
#       {
#         profile = {
#           name = "laptop-only";
#           outputs = [
#             {
#               criteria = "eDP-1";
#               scale = 1.6;
#               mode = " 2944x1840@90Hz";
#               status = "enable";
#             }
#           ];
#           exec = "hyprctl dispatch moveworkspacetomonitor 1 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 2 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 3 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 4 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 5 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 6 desc:eDP-1";
#         };
#       }
#       {
#         profile = {
#           name = "laptop-and-LG";
#           outputs = [
#             {
#               criteria = "eDP-1";
#               position = "360,1440";
#               scale = 1.6;
#               mode = " 2944x1840@90Hz";
#               status = "enable";
#             }
#             {
#               criteria = "LG Electronics LG HDR 4K 0x00035468";
#               position = "0,0";
#               scale = 1.5;
#               mode = "3840x2160@60Hz";
#               status = "enable";
#             }
#           ];
#           exec = "hyprctl dispatch moveworkspacetomonitor 1 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 2 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 3 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 4 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 5 desc:eDP-1; hyprctl dispatch moveworkspacetomonitor 6 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468";
#         };
#       }
#       {
#         profile = {
#           name = "LG-and-CEX";
#           outputs = [
#             {
#               criteria = "LG Electronics LG HDR 4K 0x00035468";
#               position = "0,0";
#               scale = 1.5;
#               mode = "3840x2160@60Hz";
#               status = "enable";
#             }
#             {
#               criteria = "CEX CX133 0x00000001";
#               position = "480,1440";
#               scale = 1.25;
#               mode = "2560x1600@60Hz";
#               status = "enable";
#             }
#           ];
#           exec = "hyprctl dispatch moveworkspacetomonitor 1 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 2 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 3 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468; hyprctl dispatch moveworkspacetomonitor 4 desc:CEX\\ CX133\\ 0x00000001; hyprctl dispatch moveworkspacetomonitor 5 desc:CEX\\ CX133\\ 0x00000001; hyprctl dispatch moveworkspacetomonitor 6 desc:LG\\ Electronics\\ LG\\ HDR\\ 4K\\ 0x00035468";
#         };
#       }
#     ];
#   };
}
