{
  ax,
  pkgs,
  ...
}:
{
  home.packages = [
    ax.packages.${pkgs.stdenv.hostPlatform.system}.ax
  ];
}
