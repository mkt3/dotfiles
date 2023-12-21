{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs =
    { nixpkgs, darwin, home-manager, ... }@inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
      {
        darwinConfigurations = {
          mercury = darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            modules = [
              ./modules/nix-core.nix
              ./modules/system.nix
              ./modules/apps.nix
              ./modules/host-users.nix

              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                programs.zsh.enable = false;
                programs.zsh.enableCompletion = false;
                programs.bash.enable = false;
                # home-manager.users.me = import ./home/darwin;
              }
            ];
          };
        };

        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      };


  nixConfig = {
    auto-optimise-store = true;

    eval-cache = true;

    substituters = [
      "https://cache.nixos.org/"
    ];
    # extra-substituters = [
    #   "https://nix-community.cachix.org"
    # ];
    # extra-trusted-public-keys = [
    #   # https://app.cachix.org/cache/nix-community#pull
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
  };
}
