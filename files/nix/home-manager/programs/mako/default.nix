{ ... }:
{
  services.mako = {
    enable = true;

    # settings（グローバルな設定）は key = value の形で書く
    settings = {
      sort = "-time";
      layer = "overlay";
      backgroundColor = "#4c566a";
      width = "700";
      height = "220";
      borderSize = "2";
      borderColor = "#88c0d0";
      borderRadius = "5";
      icons = "true";
      maxIconSize = "64";
      defaultTimeout = "5000";
      ignoreTimeout = "true";
      padding = "14";
      font = "plemoljp-nf 14";
      margin = "20";
    };

    criteria = {
      "urgency=low" = {
        border-color = "#81a1c1";
      };

      "urgency=normal" = {
        border-color = "#88c0d0";
      };

      "urgency=high" = {
        border-color = "#bf616a";
        default-timeout = "0";
      };
    };
  };
}
