{ pkgs, username, homeDirectory, dotfilesDirectory, isGUI, isCLI, ... }:
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  home.extraOutputsToInstall = ["dev"];
  imports = [
    ./system_packages.nix
    ./packages.nix
    (import ./services/default.nix {inherit pkgs isGUI isCLI;})
  ];

  programs.home-manager.enable = true;
}
