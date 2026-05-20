{ homeDirectory, ... }:

{
  programs.nh = {
    enable = true;
    flake = "${homeDirectory}/.config/nix";
    osFlake = "${homeDirectory}/.config/nix";
    homeFlake = "${homeDirectory}/.config/nix";
    darwinFlake = "${homeDirectory}/.config/nix";
  };
}
