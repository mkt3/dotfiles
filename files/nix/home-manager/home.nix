{
  pkgs,
  username,
  homeDirectory,
  lib,
  nix-index-database,
  ...
}:
{
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "25.11";
    extraOutputsToInstall = [ "dev" ];

    activation = {
      rmSomeThing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
      trusted-users = [ username ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
