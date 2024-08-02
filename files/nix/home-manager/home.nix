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
    ./services/default.nix
  ];

  programs.home-manager.enable = true;
}
