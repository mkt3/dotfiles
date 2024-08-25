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
    xremap.url = "github:xremap/nix-flake";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      emacs-overlay,
      home-manager,
      xremap,
      lanzaboote,
      nixos-hardware,
      ...
    }:
    let
      platform = "__SYSTEM__"; # aarch64-darwin or x86_64-darwin
      hostname = "__HOSTNAME__";
      username = "__USERNAME__";
      homeDirectory = "__HOMEDIRECTORY__";
      dotfilesDirectory = "__DOTFILESDIRECTORY__";
      isGUI = __ISGUI__;
      isCLI = __ISCLI__;

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = platform;
        overlays = [
          emacs-overlay.overlays.emacs
          (import ./home-manager/overlays/patched-emacs)
        ];
      };

      specialArgs = inputs // {
        inherit
          platform
          username
          hostname
          homeDirectory
          dotfilesDirectory
          isGUI
          isCLI
          ;
      };
    in
    {
      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
        inherit pkgs specialArgs;
        modules = [
          ./systems/common/host-users.nix
          ./systems/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
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
          ./systems/darwin/homebrew-apps.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          (import ./home-manager/home.nix)
        ];
      };
    };
}
