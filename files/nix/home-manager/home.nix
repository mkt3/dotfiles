{ pkgs, username, homeDirectory, isGUI, isCUI, ... }:
 {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  home.extraOutputsToInstall = ["dev"];

  imports = [
    ./packages.nix
    ./program_list.nix
    (import ./services/default.nix {inherit pkgs isGUI isCUI;})
  ];

  programs.home-manager.enable = true;
}
