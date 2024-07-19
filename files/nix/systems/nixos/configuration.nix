{ username, config, lib, pkgs, lanzaboote, nixos-hardware,  ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system_packages.nix
    lanzaboote.nixosModules.lanzaboote
    nixos-hardware.nixosModules.lenovo-yoga-7-slim-gen8
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    bootspec.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 7;
    };

  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  networking.firewall = {
    enable = true;
  };

  # Create a symlink in XDG_DATA_HOME/fonts pointing to /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 7d";
    };
  };
}
