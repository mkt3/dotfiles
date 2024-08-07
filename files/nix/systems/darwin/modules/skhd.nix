{ ... }:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - f : yabai -m space --layout float

      # restart
      alt + shift - r : yabai --restart-service

      # Finder
      alt - e:  open /System/Library/CoreServices/Finder.app

      # Toggle between bsp and stack
      alt + shift - space : [ "$(yabai -m query --spaces --space | jq -r '.type')" = bsp ] \
          && yabai -m space --layout stack \
          || yabai -m space --layout bsp

      # close
      alt - c : yabai -m window --close

      # focus window
      alt - h: yabai -m window --focus west || yabai -m display --focus west
      alt - l: yabai -m window --focus east || yabai -m display --focus east
      alt - j: yabai -m window --focus south || yabai -m display --focus south
      alt - k: yabai -m window --focus north || yabai -m display --focus north
      alt - n: yabai -m window --focus next || yabai -m display --focus next
      alt - p: yabai -m window --focus prev || yabai -m display --focus prev

      # move window
      alt + shift - h : yabai -m window --warp west || (yabai -m window --display east && yabai -m display --focus west)
      alt + shift - j : yabai -m window --warp south || (yabai -m window --display south && yabai -m display --focus south)
      alt + shift - k : yabai -m window --warp north || (yabai -m window --display north && yabai -m display --focus north)
      alt + shift - l : yabai -m window --warp east || (yabai -m window --display east && yabai -m display --focus east)

      # move window to space
      alt + shift - 1 : yabai -m window --space 1
      alt + shift - 2 : yabai -m window --space 2
      alt + shift - 3 : yabai -m window --space 3
      alt + shift - 4 : yabai -m window --space 4
      alt + shift - 0 : yabai -m window --space 5

      # move window frame
      shift + ctrl - a : yabai -m window --move rel:-20:0
      shift + ctrl - s : yabai -m window --move rel:0:20
      shift + ctrl - w : yabai -m window --move rel:0:-20
      shift + ctrl - d : yabai -m window --move rel:20:0
      shift + alt - d : yabai -m window --resize right:20:0

      # change window size
      ctrl + alt - h: yabai -m window --resize left:-40:0 || yabai -m window --resize right:-40:0
      alt - backspace: yabai -m window --resize left:-40:0 || yabai -m window --resize right:-40:0
      ctrl + alt - l: yabai -m window --resize right:20:0 || yabai -m window --resize left:20:0
      ctrl + alt - j: yabai -m window --resize bottom:0:20 || yabai -m window --resize top:0:20
      ctrl + alt - k: yabai -m window --resize top:0:-20 || yabai -m window --resize bottom:0:-20

      # rotate tree
      alt - r : yabai -m space --rotate 90
      # mirror tree y-axis
      alt - m : yabai -m space --mirror y-axis && yabai -m window --focus first
      # mirror tree x-axis
      alt - x : yabai -m space --mirror x-axis
      # toggle desktop offset
      alt - a : yabai -m space --toggle padding && yabai -m space --toggle gap
      # toggle window fullscreen zoom
      alt - space : yabai -m window --toggle zoom-fullscreen
      # navigate
      alt - 0x2B : yabai -m display --focus prev && yabai -m display --focus stack.prev
      alt - 0x2F : yabai -m display --focus next && yabai -m display --focus stack.next
      # float / unfloat window and restore position
      alt - f : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2

      # send window
      shift + alt - 0x2B : yabai -m window --display prev && yabai -m display --focus prev
      shift + alt - 0x2F : yabai -m window --display next && yabai -m display --focus next

      # reset split balance
      shift + alt - e : yabai -m space --balance
    '';
  };
}
