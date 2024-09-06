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
      "openssl"
      "readline"
      "sqlite3"
      "xz"
      "zlib"
      "tcl-tk"
    ];

    casks = [
      "firefox"
      "zotero"
      "nextcloud"
      "google-drive"
      "aquaskk"
      "karabiner-elements"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "WireGuard" = 1451685025;
    };
  };
}
