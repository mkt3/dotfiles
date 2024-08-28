{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".zshenv".text = ''
    # zoxide
    export _ZO_DATA_DIR="$XDG_DATA_HOME"
  '';
}
