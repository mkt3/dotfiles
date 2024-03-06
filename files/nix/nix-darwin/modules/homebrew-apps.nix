{ pkgs, ...}:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
    };

    taps = [
      "homebrew/cask-fonts"
    ];

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
      "libreoffice"
      "font-hack-nerd-font"
      "font-cica"
      "font-plemol-jp-nf"
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
