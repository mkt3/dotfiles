{
  pkgs,
  homeDirectory,
  hostname,
  username,
  ...
}:
{
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  networking.computerName = hostname;

  environment.shells = [ pkgs.zsh ];
  programs.bash.enable = false;

  system = {
    # defaults.smb.NetBIOSName = hostname;
    primaryUser = username;

    stateVersion = 6;

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
        NewWindowTarget = "Other";
        NewWindowTargetPath = "file:///Users/${username}/Downloads/";
      };

      controlcenter = {
        Bluetooth = true;
        Sound = true;
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

      # universalaccess.reduceTransparency = true;

      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        autohide-delay = 0.0;
        magnification = true;
        tilesize = 42;
        largesize = 96;
        show-recents = false;
        static-only = true;
        mru-spaces = false; # disable automatic rearrange spaces
        launchanim = false;
      };

      screencapture = {
        disable-shadow = true;
        location = "${homeDirectory}/Downloads";
      };

      spaces.spans-displays = true;

      CustomUserPreferences = {
        NSGlobalDomain = {
          NSAutomaticTextCompletionEnabled = 0;
          SLSMenuBarUseBlurredAppearance = 1;
        };

        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.frameworks.diskimages".auto-open-ro-root = true;

        "com.apple.finder" = {
          OpenWindowForNewRemovableDisk = true;
          ShowRecentTags = false;
          SidebarShowingiCloudDesktop = false;
          SidebarShowingSignedIntoiCloud = false;
          SidebarDevicesSectionDisclosedState = true;
          SidebarPlacesSectionDisclosedState = true;
          DisableAllAnimations = true;
        };

        "com.apple.systemuiserver" = {
          "NSStatusItem Visible Siri" = false;
          "NSStatusItem Visible com.apple.menuextra.battery" = true;
          "NSStatusItem Visible com.apple.menuextra.clock" = true;
        };

        "com.apple.screencapture".name = "ss_";

        "com.apple.TextEdit" = {
          RichText = 0;
          PlainTextEncoding = 4;
          PlainTextEncodingForWrite = 4;
        };

        "com.apple.systempreferences".TMShowUnsupportedNetworkVolumes = 1;

        # com.apple.universalaccess is protected on recent macOS releases.
        # This is the domain used by the Accessibility UI for Reduce Motion.
        "com.apple.Accessibility".ReduceMotionEnabled = 1;

        "com.apple.HIToolbox" = {
          AppleDictationAutoEnable = 1;
          AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput = 1;
        };

        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = false;
          StandardHideWidgets = true;
        };

        "com.apple.loginwindow" = {
          TALLogoutSavesState = false;
          LoginwindowLaunchesRelaunchApps = false;
        };
      };
    };
  };

  # Add ability to use TouchID for sudo authentication in tmux
  # environment = {
  #   etc."pam.d/sudo_local".text = ''
  #     # Managed by Nix Darwin
  #     auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
  #     auth       sufficient     pam_tid.so
  #   '';
  # };
}
