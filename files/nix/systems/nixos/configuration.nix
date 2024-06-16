{ username, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system_packages.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Create a symlink in XDG_DATA_HOME/fonts pointing to /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
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
