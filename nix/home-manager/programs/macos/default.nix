{
  lib,
  pkgs,
  ...
}:
{
  home.activation.macosMutablePreferences = lib.hm.dag.entryAfter [ "sharedSKKDictionary" ] ''
    ${lib.getExe pkgs.bash} ${./_setup_macos.sh}
  '';
}
