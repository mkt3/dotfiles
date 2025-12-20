{ config, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  home.file.".zshenv".text = ''
    # zoxide
    export _ZO_DATA_DIR="${config.xdg.dataHome}"
    export _ZO_FZF_OPTS="--tmux 80%"
  '';
}
