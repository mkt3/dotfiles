{ config, pkgs, ... }:
{
  programs.npm = {
    enable = true;
    package = pkgs.nodejs;
    settings = {
      prefix = "${config.xdg.dataHome}/npm";
      cache = "${config.xdg.cacheHome}/npm";
      tmp = "\${XDG_RUNTIME_DIR}/npm";
      init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
    };
  };
}
