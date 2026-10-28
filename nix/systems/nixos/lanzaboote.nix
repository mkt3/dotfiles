{ lib, lanzaboote, ... }:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 7;
    };
  };
}
