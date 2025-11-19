{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
    greedyCasks = true;

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
      "google-drive"
      "macskk"
      "recoll"
      "karabiner-elements"
    ];

    masApps = {
    };
  };
}
