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
      platform = "__SYSTEM__";
      username = "__USERNAME__";
      homeDirectory = "/home/${username}";
      pkgs = import nixpkgs {
         config.allowUnfree = true;
         system = platform;
         overlays = [ emacs-overlay.overlays.emacs
                     (import ./home-manager/overlays/patched-emacs)
                    ];
       };

    in {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs username homeDirectory;
        modules = [
           ../home-manager/home.nix
        ];
      };
    };

}
