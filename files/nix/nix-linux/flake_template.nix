{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "__SYSTEM__";
      username = "__USERNAME__";
      homeDirectory = "/Users/${username}";
    in
    {
      homeConfigurations."__USERNAME__" = home-manager.lib.homeManagerConfiguration {
        inherit nixpkgs system emacs-overlay username homeDirectory;
        modules = [
           ../home-manager/home.nix
        ];
      };
    };

}
