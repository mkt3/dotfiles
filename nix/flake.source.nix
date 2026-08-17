{
  description = "Nix system flake";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ax = {
      url = "github:yusukebe/ax";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      host = builtins.fromJSON (builtins.readFile ./host.json);
      inherit (host)
        platform
        os
        hostname
        username
        homeDirectory
        isGUI
        isDev
        ;

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        overlays = [
          (import ./home-manager/overlays/recoll)
        ];
        system = platform;
      };
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      commonSpecialArgs = inputs // {
        inputs = inputs;
        inherit
          platform
          username
          hostname
          homeDirectory
          isGUI
          isDev
          isLinux
          isDarwin
          ;
      };
    in
    nixpkgs.lib.optionalAttrs (os == "nixos") {
      nixosConfigurations."${hostname}" =
        let
          specialArgs = commonSpecialArgs // {
            os = "nixos";
            isNixOS = true;
          };
        in
        nixpkgs.lib.nixosSystem {
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
    }
    // nixpkgs.lib.optionalAttrs (os == "darwin") {
      darwinConfigurations."${hostname}" =
        let
          specialArgs = commonSpecialArgs // {
            os = "darwin";
            isNixOS = false;
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit pkgs specialArgs;
          modules = [
            ./systems/common/host-users.nix
            ./systems/darwin/system.nix
            ./systems/darwin/catalog-packages.nix
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
    }
    // nixpkgs.lib.optionalAttrs (os == "ubuntu") {
      homeConfigurations."${username}" =
        let
          specialArgs = commonSpecialArgs // {
            os = "ubuntu";
            isNixOS = false;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            { nix.package = pkgs.nix; }
            (import ./home-manager/home.nix)
          ];
        };
    };
}
