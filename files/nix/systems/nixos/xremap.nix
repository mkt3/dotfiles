{ config, pkgs, username, xremap, ... }:
{
  imports = [xremap.nixosModules.default];

  hardware.uinput.enable = true;
  users.groups.uinput.members = [username];
  users.groups.input.members = [username];
  services.xremap = {
    userName = username;
    withWlroots = true;
    serviceMode = "user";
    config = {
      keypress_delay_ms = 20;
      modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Ctrl_L";
            "KEY_102ND" = "KEY_GRAVE";
            "Alt_R" = "Ctrl_R";
            "Alt_L" = "Super_L";
            "Super_L" = "Alt_L";
          };
        }
      ];
      keymap = [
        {
          name = "Default";
          application.not = ["org.wezfurlong.wezterm" "emacs"];
          remap = {
            # Emacs basic
            "C-b" = "left";
            "C-f" = "right";
            "C-p" = "up";
            "C-n" = "down";
            "C-m" = "enter";

            # Emacs word
            "Super-b" = "C-left";
            "Super-f" = "C-right";

            # Emacs lines
            "C-a" = "home"; # TODO = Alt-C-a
            "C-e" = "end"; # TODO = Alt-C-e
            "C-k"  = ["Shift-end" "C-x"];

            # Alt -> Ctrl
            "Super-a" = "C-a";
            "Super-z" = "C-z";
            "Super-x" = "C-x";
            "Super-c" = "C-c";
            "Super-v" = "C-v";
            "Super-w" = "C-w";
            "Super-t" = "C-t";
            "Super-l" = "C-l";

            "C-h" = "backspace";
            "C-d" = "delete";
            "Super-d" = "C-delete";

            "C-g" = "Esc";
          };
        }
        {
          name = "Wezterm";
          application.only = ["org.wezfurlong.wezterm"];
          remap = {
            "Ctrl_R-c" = "C-Shift-c";
            "Ctrl_R-v" = "C-Shift-v";
            # for emacs ddskk in wezterm
            "C-Shift-j" = "C-j";
          };
        }
        {
          name = "Slack";
          application.only = ["Slack"];
          remap = {
            "Super-Shift-a" = "C-Shift-a";
            "Super-k" = "C-k";
            "C-Super-m" = "C-Enter";
            "Super-1" = "C-1";
            "Super-2" = "C-2";
            "Super-3" = "C-3";
            "Super-4" = "C-4";
            "Super-5" = "C-5";
            "Super-6" = "C-6";
            "Super-7" = "C-7";
            "Super-8" = "C-9";
            "Super-9" = "C-9";
          };
        }
        {
          name = "Vivaldi";
          application.only = ["Vivaldi-stable"];
          remap = {
            "Super-s" = "C-f";
            "Super-BTN_LEFT" = "C-BTN_LEFT";
          };
        }
      ];
    };
  };
}
