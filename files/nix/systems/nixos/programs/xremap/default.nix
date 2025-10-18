{ username, xremap, ... }:
{
  imports = [ xremap.nixosModules.default ];

  hardware.uinput.enable = true;
  users.groups.uinput.members = [ username ];
  users.groups.input.members = [ username ];
  services.xremap = {
    enable = true;
    userName = username;
    withWlroots = true;
    watch = true;
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
          device = {
            "not" = [
              "Yowkees Keyball44"
              "Apple Inc. Magic Keyboard"
            ];
          };
        }
        {
          name = "Magic Keyboard";
          remap = {
            "CapsLock" = "Ctrl_L";
            "KEY_102ND" = "KEY_GRAVE";
            "Super_R" = "Ctrl_R";
          };
          device = {
            "only" = [
              "Apple Inc. Magic Keyboard"
            ];
          };
        }
      ];
      keymap = [
        {
          name = "Default";
          application.not = [
            "org.wezfurlong.wezterm"
            "emacs"
          ];
          remap = {
            # Cursor
            "C-b" = {
              with_mark = "left";
            };
            "C-f" = {
              with_mark = "right";
            };
            "C-p" = {
              with_mark = "up";
            };
            "C-n" = {
              with_mark = "down";
            };
            # Forward/Backward word
            "Super-b" = {
              with_mark = "C-left";
            };
            "Super-f" = {
              with_mark = "C-right";
            };
            # Beginning/End of line
            "C-a" = {
              with_mark = "home";
            };
            "C-e" = {
              with_mark = "end";
            };
            # Page up/down
            "Super-v" = {
              with_mark = "pageup";
            };
            "C-v" = {
              with_mark = "pagedown";
            };
            # Beginning/End of file
            "Super-Shift-comma" = {
              with_mark = "C-home";
            };
            "Super-Shift-dot" = {
              with_mark = "C-end";
            };
            # Newline
            "C-m" = "enter";
            # Copy
            "C-w" = [
              "C-x"
              {
                set_mark = false;
              }
            ];
            "Super-w" = [
              "C-c"
              {
                set_mark = false;
              }
            ];
            "C-y" = [
              "C-v"
              {
                set_mark = false;
              }
            ];
            # Delete
            "C-d" = [
              "delete"
              {
                set_mark = false;
              }
            ];
            "Super-d" = [
              "C-delete"
              {
                set_mark = false;
              }
            ];
            "C-h" = "backspace";
            # Kill line
            "C-k" = [
              "Shift-end"
              "C-x"
              {
                set_mark = false;
              }
            ];
            # set mark next word continuously.
            "C-Super-space" = [
              "C-Shift-right"
              {
                set_mark = true;
              }
            ];
            # Undo
            "C-slash" = [
              "C-z"
              {
                set_mark = false;
              }
            ];
            # Mark
            "C-space" = {
              set_mark = true;
            };
            # Search
            "C-s" = "C-f";
            # Cancel
            "C-g" = [
              "esc"
              {
                set_mark = false;
              }
            ];
            # C-x YYY
            "C-x" = {
              remap = {
                # C-x h (select all)
                h = [
                  "C-home"
                  "C-a"
                  {
                    set_mark = true;
                  }
                ];
                "C-s" = "C-s";
                "C-c" = "C-q";
              };
            };
          };
        }
        {
          name = "Wezterm";
          application.only = [ "org.wezfurlong.wezterm" ];
          remap = {
            "Ctrl_R-c" = "C-Shift-c";
            "Ctrl_R-v" = "C-Shift-v";
            # for emacs ddskk in wezterm
            "C-Shift-j" = "C-j";
          };
        }
        {
          name = "Slack";
          application.only = [ "Slack" ];
          remap = {
            "Super-Shift-a" = "C-Shift-a";
            "Super-a" = "C-Shift-a";
            "Super-k" = "C-k";
            "Super-g" = "C-g";
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
          application.only = [ "vivaldi-stable" ];
          remap = {
            "Super-e" = "Alt-Shift-i";
            "Super-BTN_LEFT" = "C-BTN_LEFT";
          };
        }
      ];
    };
  };
}
