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
    ];

    brews = [
    ];

    casks = [
      "nextcloud"
      "google-drive"
      "aquaskk"
      "recoll"
      "karabiner-elements"
    ];

    masApps = {
      "WireGuard" = 1451685025;
    };
  };
}
