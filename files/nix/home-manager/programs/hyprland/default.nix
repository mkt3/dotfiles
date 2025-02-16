{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    settings = {
      "$mainMod" = "ALT";
      "$subMod" = "SUPER";
      bind = [
        "$mainMod, t, exec, wezterm"
        "$subMod, q, killactive"
        "$mainMod, m, exit,"
        "$mainMod, f, exec, thunar"
        "$subMod, SPACE, exec, rofi -show combi"
        # bind = $mainMod, P, pseudo, # dwindle
        # bind = $mainMod, J, togglesplit, # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        # "$mainMod, 7, workspace, 7"
        # "$mainMod, 8, workspace, 8"
        # "$mainMod, 9, workspace, 9"
        # "$mainMod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        # "$mainMod SHIFT, 7, movetoworkspace, 7"
        # "$mainMod SHIFT, 8, movetoworkspace, 8"
        # "$mainMod SHIFT, 9, movetoworkspace, 9"
        # "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        # Example special workspace (scratchpad)"
        #"$mainMod, S, togglespecialworkspace, magic"
        #"$mainMod SHIFT, S, movetoworkspace, special:magic"
        # Window toggle"
        # "=  $subMod, TAB, exec, "rofi -show window""
        "$mainMod, SPACE, fullscreen, 1"
        # Volume and Media Control
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86Calculator, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        "Alt, s, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86Favorites, exec, playerctl previous"
        # screen shot
        "$subMod SHIFT, 2, exec, hyprshot -m window -o $HOME/Downloads -f screenshot_$(date \"+%y%m%d%H%M%S\").png"
        "$subMod SHIFT, 3, exec, hyprshot -m output -o $HOME/Downloads -f screenshot_$(date \"+%y%m%d%H%M%S\").png"
        "$subMod SHIFT, 4, exec, hyprshot -m region -o $HOMEh/Downloads -f screenshot_$(date \"+%y%m%d%H%M%S\").png"

        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ];
      env = [
        "QT_IM_MODULE, fcitx"
        "XMODkIFIERS, @im=fcitx"
        "GDK_SCALE, 1.5"
        "NIXOS_OZONE_WL, 1"
      ];

      workspace = [
        "1, monitor:desc:LG Electronics LG HDR 4K 0x00035468, default:true"
        "2, monitor:desc:LG Electronics LG HDR 4K 0x00035468"
        "3, monitor:desc:LG Electronics LG HDR 4K 0x00035468"
        "4, monitor:desc:CEX CX133 0x00000001, default:true"
        "4, monitor:eDP-1, default:true"
        "5, monitor:desc:CEX CX133 0x00000001"
        "5, monitor:eDP-1"
        "6, monitor:desc:LG Electronics LG HDR 4K 0x00035468"
        # "7, monitor:eDP-1, default:true"
        # "8, monitor:eDP-1, default:true"
        # "9, monitor:eDP-1, default:true"
        # "10, monitor:eDP-1, default:true"
      ];

      xwayland = {
        force_zero_scaling = true;
      };
      exec-once = [
        "brightnessctl set 80%"
        "fcitx5 -D"
        "hypridle"
        "nm-applet --indicator"
        "waybar"
        "sleep 10; nextcloud --background"
        "[workspace 1 silent] wezterm"
        "[workspace 1 silent] vivaldi"
        "[workspace 3 silent] zotero"
        "[workspace 2 silent] slack"
        "[workspace 4 silent] COLORTERM=truecolor GTK_IM_MODULE=xim emacs"
      ];

      windowrulev2 = [
        "float ,title:(Bitwarden - Vivaldi)"
        "float ,class:(com.nextcloud.desktopclient.nextcloud)"
        "float ,class:(com.saivert.pwvucontrol)"
      ];

      input = {
        kb_layout = "us";
        repeat_delay = 300;
        repeat_rate = 50;
        follow_mouse = 1;
        sensitivity = 0.4; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "adaptive";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          scroll_factor = 1;
        };
      };

      device = {
        name = "yowkees-keyball44-mouse";
        sensitivity = -0.5;
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.inactive_border" = "rgb(2E3440)";
        "col.active_border" = "rgb(4C566A)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = false;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier, slide"
          "layers, 1, 4, myBezier, fade"
          "border, 1, 5, default"
          "fade, 1, 5, default"
          "workspaces, 1, 6, default"
        ];
      };
      dwindle = {
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      misc = {
        disable_hyprland_logo = false;
        force_default_wallpaper = 0;
      };
      master = {
        new_status = "master";
      };
    };
  };

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

  # libskk
  xdg.configFile."libskk/rules/StickyShift/metadata.json" = {
    text = ''
      {
        "name": "StickyShift",
        "description": "Typing rule, support sticky key"
      }
    '';
  };

  xdg.configFile."libskk/rules/StickyShift/keymap/hiragana.json" = {
    text = ''
      {
        "include": [
          "default/hiragana"
        ],
        "define": {
          "keymap": {
            ";": "start-preedit-no-delete"
          }
        }
      }
    '';
  };
  xdg.configFile."libskk/rules/StickyShift/keymap/katakana.json" = {
    text = ''
      {
        "include": [
          "default/katakana"
        ],
        "define": {
          "keymap": {
            ";": "start-preedit-no-delete"
          }
        }
      }
    '';
  };

  home.file.".zshenv".text = ''
    # icons
    export XCURSOR_PATH=/usr/share/icons:"''${XDG_DATA_HOME}/icons"
  '';

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles = {
      laptop-only = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.6;
            status = "enable";
            mode = " 2944x1840@90Hz";
          }
        ];
      };

      laptop-and-LG = {
        outputs = [
          {
            criteria = "LG Electronics LG HDR 4K 0x00035468";
            position = "0,0";
            scale = 1.5;
            mode = "3840x2160@60Hz";
          }
          {
            criteria = "eDP-1";
            position = "360,1440";
            scale = 1.6;
            status = "enable";
            mode = " 2944x1840@90Hz";
          }
        ];
      };
      LG-and-CEX = {
        outputs = [
          {
            criteria = "LG Electronics LG HDR 4K 0x00035468";
            position = "0,0";
            scale = 1.5;
            mode = "3840x2160@60Hz";
          }
          {
            criteria = "CEX CX133 0x00000001";
            position = "480,1440";
            scale = 1.6;
            mode = "2560x1600@60Hz";
          }
        ];
      };
      laptop-and-LG-and-CEX = {
        outputs = [
          {
            criteria = "LG Electronics LG HDR 4K 0x00035468";
            position = "0,0";
            scale = 1.5;
            mode = "3840x2160@60Hz";
          }
          {
            criteria = "CEX CX133 0x00000001";
            position = "480,1440";
            scale = 1.6;
            mode = "2560x1600@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
