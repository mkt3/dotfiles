{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "nailuoGG/recoll"
      "mtgto/macskk"
    ];

    brews = [
    ];

    casks = [
      "slack"
      "zoom"
      "vivaldi"
      "nextcloud"
      "google-drive"
      "macskk"
      "recoll"
      "karabiner-elements"
    ];

    masApps = {
      "WireGuard" = 1451685025;
    };
  };
}
