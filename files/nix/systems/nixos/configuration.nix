{
  username,
  hostname,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./system_packages.nix
  ]
  ++ (
    if hostname == "personal-lt" then
      [
        ./lanzaboote.nix
        ./personal-lt.nix
        nixos-hardware.nixosModules.lenovo-yoga-7-slim-gen8
      ]
    else if hostname == "personal-dt" then
      [
        ./nvidia.nix
        ./defaultboot.nix
      ]
    else
      [ ./defaultboot.nix ]
  );
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
      "dialout"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.nix-ld.enable = true;

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = false;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5957", ATTRS{idProduct}=="0400", MODE="0666"
    '';

    upower.enable = true;
  };

  networking.firewall = {
    enable = true;
  };

  # Create a symlink in XDG_DATA_HOME/fonts pointing to /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
