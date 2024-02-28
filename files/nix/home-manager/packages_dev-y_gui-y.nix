{ config, pkgs, ... }:

{
  home.username = "makoto.morinaga";
  home.homeDirectory = "/Users/makoto.morinaga";
  home.stateVersion = "23.11";


  home.packages = with pkgs; [
    cmake
    mas
    zsh
    bash
    fzf
    findutils
    gnugrep
    gnused
    gawk
    less
    jq
    tree
    duf
    neofetch
    unar
    rsync
    trash-cli
    tmux
    git
    procs
    bat
    fd
    ripgrep
    delta
    lsd
    dust
    csview
    zoxide
    navi
    lazygit
    openssl_3_2
    gnupg
    pinentry_mac
    pam-reattach
    darwin.iproute2mac
    wget
    curl
    aria
    htop
    vim
    ghq
    shellcheck-minimal
    python311Full
    ruff
    nodePackages.pyright
    python311Packages.jupyterlab
    uv
    poetry
    mise
    nodePackages.bash-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.typescript-language-server
    typescript
    google-cloud-sdk
    recoll
    poppler
    hugo
    nodePackages.gatsby-cli
    goimapnotify
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
