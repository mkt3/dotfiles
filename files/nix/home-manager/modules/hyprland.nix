{config, pkgs, ... }:
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
        "$mainMod SHIFT, m, exit"
        "$mainMod, q, killactive"
        "$mainMod, m, exit,"
        "$mainMod, e, exec, $fileManager"
        "$mainMod, v, togglefloating,"
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
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
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
        "HYPRCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME,Nordzy-cursors"
      ];
      monitor = [
        "eDP-1,preferred,auto-down,1.6"
        "DP-3,preferred,auto-up,1.5"
      ];

      workspace = [
        "1, monitor:DP-3, default:true"
        "2, monitor:DP-3"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-3"
        "6, monitor:DP-3"
        "7, monitor:DP-3"
        "8, monitor:DP-3"
        "9, monitor:eDP-1, default:true"
        "10, monitor:DP-3"
      ];

      xwayland = {
        force_zero_scaling = true;
      };
      exec-once = [
        "brightnessctl set 80%"
        "fcitx5 -D"
        "nm-applet --indicator"
        "waybar"
        "[workspace 1 silent] wezterm"
        "[workspace 1 silent] vivaldi --enable-wayland-ime"
        "[workspace 1 silent] zotero"
        "[workspace 2 silent] slack"
        "[workspace 9 silent] COLORTERM=truecolor GTK_IM_MODULE=xim emacs"
      ];

      input = {
        kb_layout ="us";
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
      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.inactive_border" = "rgb(4C566A)";
        "col.active_border" = "rgb(4C566A)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 0.8;
        drop_shadow = true;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
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
}
