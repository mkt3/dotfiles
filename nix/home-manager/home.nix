{
  lib,
  pkgs,
  os,
  isGUI,
  username,
  homeDirectory,
  nix-index-database,
  ...
}:
{
  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
    preferXdgDirectories = true;
    extraOutputsToInstall = [ "dev" ];
  };

  xdg.enable = true;

  # Keep the Git checkout available to graphical SKK clients on both NixOS and
  # macOS. The script never initiates interactive GitHub authentication.
  home.activation.sharedSKKDictionary = lib.mkIf isGUI (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.git
          pkgs.gh
          pkgs.openssh
        ]
      }:"$PATH" \
        SSH_AUTH_SOCK="$(${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-ssh-socket)" \
        ${lib.getExe pkgs.bash} ${./_setup_skk_dict.sh}
    ''
  );

  # Keep paper notes available to Zotero, Citar, and Org-roam on GUI hosts.
  # The script never overwrites local changes or starts GitHub authentication.
  home.activation.paperNotes = lib.mkIf isGUI (
    lib.hm.dag.entryAfter [ "sharedSKKDictionary" ] ''
      PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.git
          pkgs.gh
          pkgs.openssh
        ]
      }:"$PATH" \
        SSH_AUTH_SOCK="$(${lib.getExe' pkgs.gnupg "gpgconf"} --list-dirs agent-ssh-socket)" \
        ORG_ROAM_DIR="${homeDirectory}/${
          if os == "darwin" then "GoogleDrive/local_data_dir" else "Nextcloud"
        }/orgnotes/roam" \
        ${lib.getExe pkgs.bash} ${./_setup_paper_notes.sh}
    ''
  );

  imports = [
    ./catalog-packages.nix
    nix-index-database.homeModules.default
  ];

  programs = {
    home-manager.enable = true;
    nix-index-database.comma.enable = true;
  };

  nix = {
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 0;
    };

    gc = lib.mkIf (os == "ubuntu") {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
