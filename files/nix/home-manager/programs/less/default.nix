{ pkgs, ... }:
{
  home.packages = [ pkgs.less ];

  home.file.".zshenv".text = ''
    # less
    export LESS='-g -i -M -R -S -W -x4'
  '';
}
