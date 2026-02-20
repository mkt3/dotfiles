{
  username,
  homeDirectory,
  lib,
  nix-index-database,
  ...
}:
{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";
    extraOutputsToInstall = [ "dev" ];

    activation = {
      rmSomething = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf ${homeDirectory}/.nix-defexpr
        rm -rf ${homeDirectory}/.nix-profile
      '';
    };
  };

  xdg.enable = true;

  imports = [
    ./system_packages.nix
    ./packages.nix
    nix-index-database.homeModules.default
  ];

  programs = {
    home-manager.enable = true;
    nix-index-database.comma.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
      cores = 0;
      download-buffer-size = 134217728;
      trusted-users = [ username ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
