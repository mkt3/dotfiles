{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    fzf
    findutils
    gnugrep
    gnused
    gawk
    less
    yj
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
    wget
    curl
    aria
    htop
    iotop
    vim
    hunspell
    hunspellDicts.en-us
    enchant
    isync
    msmtp
    mu
    goimapnotify
    ghq
    shellcheck-minimal
    python311Full
    ruff
    nodePackages.pyright
    python311Packages.jupyterlab
    uv
    mise
    nodePackages.bash-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.typescript-language-server
    typescript
    google-cloud-sdk
    texliveMedium
    slack
    discord
    zoom-us
    vivaldi
    vivaldi-ffmpeg-codecs
    firefox
    vlc
    libdvdread
    libdvdnav
    libdvdcss
    zotero
    anki-bin
    libreoffice-fresh
    recoll
    hugo
    nodePackages.gatsby-cli
    borgbackup
    dvdplusrwtools
  ];
}