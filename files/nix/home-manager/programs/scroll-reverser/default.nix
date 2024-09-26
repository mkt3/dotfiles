{ pkgs, ... }:
{
  home.packages = [
    (import ../../packages/scroll-reverser { inherit pkgs; })
  ];
}
