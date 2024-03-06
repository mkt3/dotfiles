{ username, homeDirectory, ... }:
 {
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  home.extraOutputsToInstall = ["dev"];

  imports = [
    ./packages.nix
    ./program_list.nix
  ];

  programs.home-manager.enable = true;
}
