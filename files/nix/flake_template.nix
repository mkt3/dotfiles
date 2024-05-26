{
  description = "Nix system flake";

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
      homeDirectory = "__HOMEDIRECTORY__";
      isGUI = __ISGUI__;
      isCUI = __ISCUI__;

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
        nixosConfigurations."${hostname}"= nixpkgs.lib.nixosSystem {
          inherit pkgs specialArgs;
          modules = [
            ./systems/common/host-users.nix
            ./systems/nixos/configuration.nix
            ./systems/common/fonts.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home-manager/home.nix {
                inherit pkgs username homeDirectory isGUI isCUI;
              };
            }
          ];
        };
        darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
          inherit pkgs specialArgs;
          modules = [
            ./systems/common/nix-core.nix
            ./systems/common/host-users.nix
            ./systems/darwin/system.nix
            ./systems/darwin/system_packages.nix
            ./systems/common/fonts.nix
            ./systems/darwin/homebrew-apps.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home-manager/home.nix {
                inherit pkgs username homeDirectory isGUI isCUI;
              };
            }
          ];
        };
        homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./home-manager/home.nix { inherit pkgs username homeDirectory isGUI isCUI;})
          ];
        };
      };
}
