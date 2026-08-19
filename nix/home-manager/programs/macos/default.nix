{
  lib,
  pkgs,
  ...
}:
{
  home.activation.macosMutablePreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=${lib.makeBinPath [
      pkgs.git
      pkgs.gh
    ]}:"$PATH" ${lib.getExe pkgs.bash} ${./_setup_macos.sh}
  '';
}
