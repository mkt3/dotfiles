{
  lib,
  os,
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
