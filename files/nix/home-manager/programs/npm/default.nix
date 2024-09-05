{ ... }:
{
  xdg.configFile."npm/npmrc" = {
    text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';
  };

  home.file.".zshenv".text = ''
    # node path
    export NPM_CONFIG_USERCONFIG="''${XDG_CONFIG_HOME}/npm/npmrc"
    export PATH="''${PATH}:''${XDG_DATA_HOME}/npm/bin"
  '';
}
