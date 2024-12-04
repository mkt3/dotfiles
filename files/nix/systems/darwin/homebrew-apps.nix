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
      "mtgto/macskk"
    ];

    brews = [
    ];

    casks = [
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
