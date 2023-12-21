{ pkgs, ...}: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    findutils
    gnused
    gnugrep
    htop
    duf
    tree
    gnupg
    less
    rsync
    python311Full
    python311Packages.pipx
    trash-cli
    neofetch
    jq
    # ncurses
    tmux
    vim
    bash
    go
    cmake
    aria
    unar
    shellcheck-minimal
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      # "homebrew/cask"
      "homebrew/cask-fonts"
      # "homebrew/services"
      # "homebrew/cask-versions"
    ];

    # `brew install`
    brews = [
      "coreutils"
      "pinentry-mac"
      "iproute2mac"
      "hugo"
      "pam-reattach" # for TouchID with sudo
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "monitorcontrol"
      "wezterm"
      "alfred"
      "discord"
      "zoom"
      "firefox"
      "vivaldi"
      "google-chrome"
      "google-drive"
      "vlc"
      "zotero"
      "stats"
      "anki"
      "font-cica"
      "font-plemol-jp-nf"
      "appcleaner"
      "aquaskk"
      "karabiner-elements"
      "nextcloud"
      "libreoffice"
    ];
    masApps = {
      "Slack" = 803453959;
      "The Unarchiver" = 425424353;
      "MeetingBar" =  1532419400;
      "WireGuard" = 1451685025;
      "Bitwarden" = 1352778147;
    };
  };
}
