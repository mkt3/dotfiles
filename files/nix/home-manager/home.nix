{ pkgs, username, homeDirectory, isGUI, isCUI, ... }:
 {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  home.extraOutputsToInstall = ["dev"];

  imports = [
    ./system_packages.nix
    ./packages.nix
    (import ./services/default.nix {inherit pkgs isGUI isCUI;})
  ];

  programs.home-manager.enable = true;
}
