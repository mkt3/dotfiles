{ config, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd j" ];
  };

  home.file.".zshenv".text = ''
    # zoxide
    export _ZO_DATA_DIR="${config.xdg.dataHome}"
  '';
}
