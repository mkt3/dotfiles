{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;
  environment.pathsToLink = ["/share/hunspell"];
  environment.systemPackages =
    [ pkgs.hunspell
      pkgs.hunspellDicts.en_US
    ];
}
