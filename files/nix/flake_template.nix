{
  description = "Nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      emacs-overlay,
      home-manager,
      nix-index-database,
      xremap,
      lanzaboote,
      nixos-hardware,
      ...
    }:
    let
      platform = "__SYSTEM__";
      hostname = "__HOSTNAME__";
      username = "__USERNAME__";
      homeDirectory = "__HOMEDIRECTORY__";
      isGUI = "__ISGUI__";

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = platform;
        overlays = [
          emacs-overlay.overlays.emacs
          (import ./home-manager/overlays/vlc)
        ]
        ++ (
          if platform == "aarch64-darwin" then
            [
              (import ./home-manager/overlays/patched-emacs/emacs-unstable.nix)
              inputs.brew-nix.overlays.default
            ]
          else if platform == "x86_64-linux" && isGUI then
            [
              (import ./home-manager/overlays/patched-emacs/emacs-unstable-pgtk.nix)
            ]
          else
            [
              (import ./home-manager/overlays/patched-emacs/emacs-unstable-nox.nix)
            ]
        );
      };
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      isNixOS =
        pkgs.stdenv.hostPlatform.isLinux && (builtins.match ".*nixos.*" (pkgs.stdenv.system) != null);

      specialArgs = inputs // {
        inherit
          platform
          username
          hostname
          homeDirectory
          isGUI
          isLinux
          isDarwin
          isNixOS
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
          { nix.package = pkgs.nix; }
          (import ./home-manager/home.nix)
        ];
      };
    };
}
