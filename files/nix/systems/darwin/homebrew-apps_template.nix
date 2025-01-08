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

    brews = [__BREW_PACKAGES__
    ];

    casks = [__CASK_PACKAGES__
    ];

    masApps = {__MAS_PACKAGES__
    };
  };
}
