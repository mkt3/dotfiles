{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;
}
