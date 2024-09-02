{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
    };

    taps = [
      "nailuoGG/recoll"
      "nikitabobko/tap"
    ];

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
      "nextcloud"
      "google-drive"
      "nikitabobko/tap/aerospace"
      "aquaskk"
      "recoll"
      "karabiner-elements"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "MeetingBar" = 1532419400;
      "WireGuard" = 1451685025;
    };
  };
}
