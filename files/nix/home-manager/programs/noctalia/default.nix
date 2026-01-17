{ config, pkgs, noctalia, ... }:
{
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 0;
      bar = {
        position = "top";
        monitors = [ ];
        density = "default";
        showOutline = false;
        showCapsule = true;
        capsuleOpacity = 1;
        backgroundOpacity = 1;
        useSeparateOpacity = false;
        floating = false;
        marginVertical = 4;
        marginHorizontal = 4;
        outerCorners = true;
        exclusive = true;
        hideOnOverview = false;
        widgets = {
          left = [
            {
              id = "Workspace";
              characterCount = 10;
              labelMode =  "name";
              colorizeIcons =  false;
              enableScrollWheel = true;
              followFocusedScreen =  false;
              groupedBorderOpacity =  1;
              hideUnoccupied =  false;
              iconScale =  0.8;
              showApplications =  false;
              showLabelsOnlyWhenOccupied =  true;
              unfocusedIconsOpacity =  1;
            }

            {
              id = "Launcher";
              usePrimaryColor = false;
            }
            # {
            #   id = "MediaMini";
            # }
          ];
          center = [
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth =  300;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = false;
            }
          ];
          right = [
            {
              id =  "VPN";
              displayMode = "alwaysShow";
            }
            {
              id = "Network";
              displayMode = "onhover";

            }
            {
              id = "NotificationHistory";
              showUnreadBadge = true;
              hideWhenZero =  false;
            }
            {
              id = "Battery";
              deviceNativePath = "";
              displayMode = "onhover";
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
              warningThreshold = 30;
            }
            {
              id = "Bluetooth";
              displayMode =  "onhover";
            }
            {
              id = "Brightness";
              displayMode = "onhover";
            }
            {
              id = "Volume";
              displayMode = "onhover";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              id = "Clock";
              customFont = "";
              formatHorizontal = "yyyy/MM/dd HH:mm";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
            }
            {
              id = "Tray";
              blacklist = [ ];
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              pinned = [ ];
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              useDistroLogo = false;
            }
          ];
        };
      };
      general = {
        avatarImage = "${config.home.homeDirectory}/Nextcloud/Picture/icon/portrait.png";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = true;
        compactLockScreen = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        showHibernateOnLockScreen = false;
        enableShadows = false;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
        showChangelogOnStartup = true;
        telemetryEnabled = true;
      };
      ui = {
        fontDefault = "Noto Sans CJK JP";
        fontFixed = "Noto Sans Mono CJK JP";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        networkPanelView = "wifi";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
      };
      location = {
        name = "Tokyo";
        weatherEnabled = true;
        weatherShowEffects = false;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = false;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherTimezone = false;
        hideWeatherCityName = false;
      };
      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
        ];
      };
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "";
        monitorDirectories = [ ];
        enableMultiMonitorDirectories = false;
        recursiveSearch = false;
        setWallpaperOnAllMonitors = true;
        fillMode = "crop";
        fillColor = "#000000";
        useSolidColor = false;
        solidColor = "#1a1a2e";
        randomEnabled = false;
        wallpaperChangeMode = "random";
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        transitionEdgeSmoothness = 0.05;
        panelPosition = "follow_bar";
        hideWallpaperFilenames = false;
        useWallhaven = false;
        wallhavenQuery = "";
        wallhavenSorting = "relevance";
        wallhavenOrder = "desc";
        wallhavenCategories = "111";
        wallhavenPurity = "100";
        wallhavenRatios = "";
        wallhavenApiKey = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenResolutionHeight = "";
      };
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        position = "center";
        pinnedApps = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "list";
        showCategories = false;
        iconMode = "tabler";
        showIconBackground = false;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "";
      };
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = false;
            id = "media-sysmon-card";
          }
        ];
      };
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        cpuPollingInterval = 10000;
        tempPollingInterval = 10000;
        gpuPollingInterval = 10000;
        enableDgpuMonitoring = false;
        memPollingInterval = 10000;
        diskPollingInterval = 10000;
        networkPollingInterval = 10000;
        loadAvgPollingInterval = 10000;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
      };
      dock = {
        enabled = false;
        position = "bottom";
        displayMode = "auto_hide";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
      };
      network = {
        wifiEnabled = true;
        bluetoothRssiPollingEnabled = false;
        bluetoothRssiPollIntervalMs = 10000;
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
      };
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        largeButtonsStyle = false;
        largeButtonsLayout = "grid";
        showNumberLabels = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };
      notifications = {
        enabled = true;
        monitors = [ ];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          criticalSoundFile = "";
          normalSoundFile = "";
          lowSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
        };
      };
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [
          0
          1
          2
        ];
        monitors = [ ];
      };
      audio = {
        volumeStep = 1;
        volumeOverdrive = false;
        cavaFrameRate = 5;
        visualizerType = "linear";
        mprisBlacklist = [ ];
        preferredPlayer = "";
      };
      brightness = {
        brightnessStep = 1;
        enforceMinimum = true;
        enableDdcSupport = true;
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Nord";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
      };
      templates = {
        gtk = false;
        qt = false;
        kcolorscheme = false;
        alacritty = false;
        kitty = false;
        ghostty = false;
        foot = false;
        wezterm = false;
        fuzzel = false;
        discord = false;
        pywalfox = false;
        vicinae = false;
        walker = false;
        code = false;
        spicetify = false;
        telegram = false;
        cava = false;
        yazi = false;
        emacs = false;
        niri = false;
        hyprland = false;
        mango = false;
        zed = false;
        helix = false;
        zenBrowser = false;
        enableUserTemplates = false;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
        screenLock = "";
        screenUnlock = "";
        performanceModeEnabled = "";
        performanceModeDisabled = "";
      };
      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [ ];
      };
    };
  };

  home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${config.home.homeDirectory}/Nextcloud/Picture/wallpaper/nord.png";
      };
    };
}
