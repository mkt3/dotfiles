{ lib, lanzaboote, ... }:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
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
}
