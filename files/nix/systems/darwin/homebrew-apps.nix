{ pkgs, ...}:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
    };

    taps = [ "nailuoGG/recoll" ];

    brews = [
      "gnu-sed"
      "openssl"
      "readline"
      "sqlite3"
      "xz"
      "zlib"
      "tcl-tk"
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
      "recoll"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "MeetingBar" = 1532419400;
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
    };
  };
}
