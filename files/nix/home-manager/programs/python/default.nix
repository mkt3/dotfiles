{ config, ... }:
{
  programs.matplotlib = {
    enable = true;
    config = {
      "font.serif:Noto" = "Sans CJK JP";
      "font.sans-serif" = "Noto Sans CJK JP";
    };
  };

  home.file.".zshenv".text = ''
    # python
    export PYTHONUSERBASE="${config.home.homeDirectory}/.local"
    export PYTHONDONTWRITEBYTECODE=1

    # ipython path
    export IPYTHONDIR="${config.xdg.configHome}/jupyter"
  '';
}
