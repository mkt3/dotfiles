{
  lib,
  pkgs,
  ...
}:
{
  home.activation.macosMutablePreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.getExe pkgs.bash} ${./_setup_macos.sh}
  '';
}
