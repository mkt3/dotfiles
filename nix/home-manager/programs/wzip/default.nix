{ pkgs, lib, ... }:

let
  sevenZip = lib.getExe' pkgs.p7zip "7z";
  wzip = pkgs.writeShellScriptBin "wzip" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$#" -lt 2 ]; then
      echo "Usage: wzip <output_zip_name.zip> <file_or_dir> [...]"
      exit 1
    fi

    OUT="$1"
    shift

    '${sevenZip}' a -tzip -mx=9 -mcu "$OUT" "$@" -xr!*.DS_Store -xr!__MACOSX

    echo "Created ZIP: $OUT"
  '';
in
{
  home.packages = [ wzip ];
}
