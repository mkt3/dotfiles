{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    bootspec.enable = true;
  };
}
