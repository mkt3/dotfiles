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

    taps = [ ];

    brews = [
      "pdfpc"
    ];

    casks = [
      "macskk"
      "vivaldi"
      "google-drive"
      "karabiner-elements"
    ];

    masApps = {
    };
  };
}
