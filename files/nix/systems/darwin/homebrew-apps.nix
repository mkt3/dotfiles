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
    ];

    brews = [
      "pdfpc"
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
    };
  };
}
