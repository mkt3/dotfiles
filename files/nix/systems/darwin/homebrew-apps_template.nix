{ pkgs, ...}:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
    };

    brews = [__BREW_PACKAGES__
    ];

    casks = [__CASK_PACKAGES__
    ];

    masApps = {__MAS_PACKAGES__
    };
  };
}
