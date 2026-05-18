{ pkgs, lib, config, ... }:
{
  home.packages = [ pkgs.nodejs ];

  programs.zsh.envExtra = lib.mkAfter ''
    # npm
    export NPM_CONFIG_USERCONFIG="${config.xdg.configHome}/npm/npmrc"
  '';

  xdg.configFile."npm/npmrc" = {
    text = ''
         prefix=${config.xdg.dataHome}/npm
         cache=${config.xdg.cacheHome}/npm
         tmp=$${XDG_RUNTIME_DIR}/npm
         init-module=${config.xdg.configHome}/npm/config/npm-init.js
     '';
  };
}
