{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      pager = "less -F -R";
      italic-text = "always";
    };
  };

  home.file.".zshenv".text = ''
    # bat for man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  '';

}
