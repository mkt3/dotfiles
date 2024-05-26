{ pkgs, ...}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
    };

    brews = [
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
      "FelixKratz/formulae/sketchybar"
    ];

    casks = [
      "vivaldi"
      "firefox"
      "vlc"
      "zotero"
      "wezterm"
      "nextcloud"
      "google-drive"
      "aquaskk"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "MeetingBar" = 1532419400;
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
    };
  };
}
