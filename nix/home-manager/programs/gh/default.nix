{ lib, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      alias = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  xdg.configFile."gh/config.yml".force = lib.mkDefault true;
}
