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
      "macskk"
      "vivaldi"
      "google-drive"
      "recoll"
      "karabiner-elements"
    ];

    masApps = {
    };
  };
}
