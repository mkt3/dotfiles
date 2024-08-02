{ ... }:
{
  services.yabai = {
    enable = true;
    config = {
      external_bar = "all:35:0";
      follows_focus = "on";
      focus_follows_mouse = "off";
      window_origin_display = "default";
      window_placement = "second_child";
      window_topmost = "off";
      window_shadow = "on";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.90";
      window_border = "on";
      window_border_width = 6;
      active_window_border_color = "0xff3D918C";
      normal_window_border_color = "0xff555555";
      insert_feedback_color = "0xffd75f5f";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      # general space settings
      layout = "bsp";
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 6;
    };
    extraConfig = ''
      # Rules
      yabai -m rule --add app='^recoll$'                        manage=off
      yabai -m rule --add app='^Dictionaries$'                  manage=off
      yabai -m rule --add app='^Disk Utility$'                  manage=off
      yabai -m rule --add app='^System Settings$'               manage=off
      yabai -m rule --add app='^Bitwarden$'                     manage=off
      yabai -m rule --add app='^Karabiner-Elements$'            manage=off
      yabai -m rule --add app='^Karabiner-MultitouchExtension$' manage=off
      yabai -m rule --add app='^Stats$'                         manage=off
      yabai -m rule --add app='^Vivaldi$' title='Bitwarden - Vivaldi'  manage=off
      yabai -m rule --add label='About This Mac' app='System Information' title='About This Mac' manage=off
      yabai -m rule --add label='Finder' app='^Finder$' title='(Co(py|nnect)|Move|Info|Pref)' manage=off
      yabai -m rule --add app='^Emacs$' manage=on
    '';
  };
}
