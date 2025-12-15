{ pkgs, ... }:
{

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-skk
        fcitx5-nord
      ];
      settings = {
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "skk";
          };
          "Groups/0/Items/0" = {
            Name = "skk";
            Layout = "";
          };
        };
        globalOptions = {
          Behavior = {
            ActiveByDefault = false;
            resetStateWhenFocusIn = "No";
            ShareInputState = "No";
            PreeditEnabledByDefault = true;
            ShowInputMethodInformation = true;
            showInputMethodInformationWhenFocusIn = false;
            CompactInputMeathodInformation = true;
            ShowFirstInputMethodInformation = true;
            DefaultPageSize = 5;
            OverrideXkbOption = false;
            CustomXkbOption = "";
            EnabledAddons = "";
            DisabledAddons = "";
            PreloadInputMethod = true;
            AllowInputMethodForPassword = false;
            ShowPreeditForPassword = false;
            AutoSavePeriod = 30;
          };
          Hotkey = {
            TriggerKeys = "";
            EnumerateWithTriggerKeys = true;
            EnumerateForwardKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateSkipFirst = false;
            ModifierOnlyKeyTimeout = 250;

          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };
          "Hotkey/ActivateKeys" = {
            "0" = "Hangul_Hanja";
          };
          "Hotkey/DeactivateKeys" = {
            "0" = "Hangul_Romaja";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };

        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = "False";
            WheelForPaging = "False";
            Font = "Sans 10";
            MenuFont = "Sans 10";
            TrayFont = "Sans Bold 10";
            TrayOutlineColor = "#000000";
            TrayTextColor = "#ffffff";
            PreferTextIcon = "False";
            ShowLayoutNameInIcon = "True";
            UseInputMethodLanguageToDisplayText = "True";
            Theme = "Nord-Dark";
            DarkTheme = "Nord-Dark";
            UseDarkTheme = "False";
            UseAccentColor = "True";
            PerScreenDPI = "False";
            ForceWaylandDPI = 0;
            EnableFractionalScale = "True";
          };
          clipboard.globalSection = {
            TriggerKey = "";
            PastePrimaryKey = "";
            "Number of entries" = 5;
            IgnorePasswordFromPasswordManager = "False";
            ShowPassword = "False";
            ClearPasswordAfter = "30";
          };
          notifications.globalSection = {
            HiddenNotifications = "";
          };
          quickphrase.globalSection = {
            TriggerKey = "";
            "Choose Modifier" = "None";
            Spell = "True";
            FallbackSpellLanguage = "en";
          };
          skk = {
            globalSection = {
              Rule = "StickyShift";
              PunctuationStyle = "Japanese";
              InitialInputMode = "Latin";
              PageSize = 7;
              "Candidate Layout" = "Vertical";
              EggLikeNewLine = "True";
              ShowAnnotation = "True";
              CandidateChooseKey = "Digit (0,1,2,...)";
              NTriggersToShowCandWin = 4;
            };
            sections = {
              CandidatesPageUpKey = {
                "0" = "Page_Up";
              };
              CandidatesPageDownKey = {
                "0" = "Next";
              };
              CursorUp = {
                "0" = "Up";
              };
              CursorDown = {
                "0" = "Down";
              };
            };
          };

        };
      };
    };
  };

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

}
