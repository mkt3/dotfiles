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
    settings =
      {
        use-xdg-base-directories = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        cores = 0;
      }
      // lib.optionalAttrs (os == "ubuntu") {
        fallback = true;
        extra-substituters = [
          "https://attic.mkt3.dev/dotfiles"
        ];
        extra-trusted-public-keys = [
          "dotfiles:yGnrUjr7sB73uHLMByDpZKW4CKY6pzFBknFQ2CKv8q0="
        ];
      };

    gc = lib.mkIf (os == "ubuntu") {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
