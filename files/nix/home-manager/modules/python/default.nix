{ ... }:
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
    export PYTHONUSERBASE="''${HOME}/.local"
    export PYTHONDONTWRITEBYTECODE=1

    # ipython path
    export IPYTHONDIR="''${XDG_CONFIG_HOME}/jupyter"
  '';
}
