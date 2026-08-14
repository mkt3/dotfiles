{ config, ... }:
let
  nord = import ../nord/palette.nix;
in
{
  programs.k9s = {
    enable = true;

    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = " roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };

    settings = {
      k9s = {
        liveViewAutoRefresh = false;
        gpuVendors = { };
        screenDumpDir = "${config.xdg.stateHome}/k9s/screen-dumps";
        refreshRate = 2;
        apiServerTimeout = "2m0s";
        maxConnRetry = 5;
        readOnly = false;
        noExitOnCtrlC = false;
        portForwardAddress = "localhost";
        ui = {
          enableMouse = false;
          headless = false;
          logoless = false;
          crumbsless = false;
          splashless = false;
          reactive = false;
          noIcons = false;
          defaultsToFullScreen = false;
          useFullGVRTitle = false;
          skin = "nord";
        };

        skipLatestRevCheck = false;
        disablePodCounting = false;
        shellPod = {
          image = "busybox:1.35.0";
          namespace = "default";
          limits = {
            cpu = "100m";
            memory = "100Mi";
          };
        };
        imageScans = {
          enable = false;
          exclusions = {
            namespaces = [ ];
            labels = { };
          };
        };
        logger = {
          tail = 100;
          buffer = 5000;
          sinceSeconds = -1;
          textWrap = false;
          disableAutoscroll = false;
          showTime = false;
        };
        thresholds = {
          cpu = {
            critical = 90;
            warn = 70;
          };
          memory = {
            critical = 90;
            warn = 70;
          };
        };
        defaultView = "pods";
      };
    };

    skins.nord.k9s = {
      body = {
        fgColor = nord.text;
        bgColor = nord.background;
        logoColor = nord.accent;
      };
      prompt = {
        fgColor = nord.textBright;
        bgColor = nord.background;
        suggestColor = nord.accent;
      };
      info = {
        fgColor = nord.accent;
        sectionColor = nord.accentBlue;
      };
      dialog = {
        fgColor = nord.text;
        bgColor = nord.surface;
        buttonFgColor = nord.background;
        buttonBgColor = nord.accent;
        buttonFocusFgColor = nord.background;
        buttonFocusBgColor = nord.textBright;
        labelFgColor = nord.text;
        fieldFgColor = nord.accent;
      };
      frame = {
        border = {
          fgColor = nord.muted;
          focusColor = nord.accent;
        };
        menu = {
          fgColor = nord.text;
          keyColor = nord.accent;
          numKeyColor = nord.purple;
        };
        crumbs = {
          fgColor = nord.background;
          bgColor = nord.accentDark;
          activeColor = nord.accent;
        };
        status = {
          newColor = nord.accent;
          modifyColor = nord.warning;
          addColor = nord.success;
          errorColor = nord.danger;
          highlightColor = nord.accentBlue;
          killColor = nord.muted;
          completedColor = nord.success;
        };
        title = {
          fgColor = nord.textBright;
          bgColor = nord.background;
          highlightColor = nord.accent;
          counterColor = nord.purple;
          filterColor = nord.accentAlt;
        };
      };
      views = {
        charts = {
          bgColor = nord.background;
          defaultDialColors = [
            nord.accent
            nord.accentBlue
          ];
          defaultChartColors = [
            nord.accent
            nord.accentBlue
          ];
        };
        table = {
          fgColor = nord.text;
          bgColor = nord.background;
          cursorFgColor = nord.textBright;
          cursorBgColor = nord.selection;
          markColor = nord.purple;
          header = {
            fgColor = nord.textBright;
            bgColor = nord.surface;
            sorterColor = nord.accent;
          };
        };
        xray = {
          fgColor = nord.text;
          bgColor = nord.background;
          cursorColor = nord.selection;
          graphicColor = nord.accent;
          showIcons = true;
        };
        yaml = {
          keyColor = nord.accent;
          colonColor = nord.muted;
          valueColor = nord.text;
        };
        logs = {
          fgColor = nord.text;
          bgColor = nord.background;
          indicator = {
            fgColor = nord.accent;
            bgColor = nord.background;
            toggleOnColor = nord.success;
            toggleOffColor = nord.muted;
          };
        };
      };
    };
  };
}
