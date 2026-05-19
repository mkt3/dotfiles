{
  description = "Nix system flake";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nix-darwin,
      nixpkgs,
      emacs-overlay,
      home-manager,
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
        ]
        ++ nixpkgs.lib.optionals (platform == "aarch64-darwin") [
          inputs.brew-nix.overlays.default
        ];
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
