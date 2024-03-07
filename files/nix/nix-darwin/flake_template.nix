{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, emacs-overlay, home-manager, ...}:
    let
      platform = "__SYSTEM__"; # aarch64-darwin or x86_64-darwin
      hostname = "__HOSTNAME__";

      username = "__USERNAME__";
      homeDirectory = "/Users/${username}";

       pkgs = import nixpkgs {
         config.allowUnfree = true;
         system = platform;
         overlays = [ emacs-overlay.overlays.emacs
                     (import ./home-manager/overlays/patched-emacs)
                    ];
       };

      specialArgs =
        inputs
        // {
          inherit platform username hostname homeDirectory;
        };
    in
      {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
          inherit pkgs specialArgs;
          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/homebrew-apps.nix
            ./modules/host-users.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home-manager/home.nix {
                inherit username homeDirectory;
              };
            }
          ];
        };
      };
}
