{ pkgs, hostname, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{
  networking.computerName = hostname;
  environment.shells = [ pkgs.zsh ];
  programs.bash.enable = false;

  system = {
    defaults.smb.NetBIOSName = hostname;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.InitialKeyRepeat = 15;
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.AppleKeyboardUIMode = 3;
      NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
      trackpad.TrackpadThreeFingerDrag = true;

      finder = {
        _FXShowPosixPathInTitle = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        FXDefaultSearchScope = "Sccf";
        FXPreferredViewStyle = "clmv";
      };

      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
      NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
      NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
      NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
      NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
      NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
      NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;

      NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
      NSGlobalDomain.AppleMetricUnits = 1;
      NSGlobalDomain.AppleTemperatureUnit = "Celsius";

      NSGlobalDomain._HIHideMenuBar = true;

      universalaccess.reduceTransparency = true;

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        magnification = true;
        tilesize = 42;
        largesize = 96;
        show-recents = false;
        static-only = true;
        mru-spaces = false; # disable automatical rearrange spaces
      };

      screencapture = {
        disable-shadow = true;
        location = "~/Downloads";
      };

    };
  };


  # Add ability to used TouchID for sudo authentication in tmux
  environment = {
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };
}
