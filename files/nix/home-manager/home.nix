{ username, homeDirectory, ... }:
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  home.extraOutputsToInstall = [ "dev" ];

  xdg.enable = true;

  imports = [
    ./system_packages.nix
    ./packages.nix
  ];

  programs.home-manager.enable = true;

  nix.gc = {
    automatic = true;
    frequency = "daily";
    options = "--delete-older-than 3d";
  };
}
