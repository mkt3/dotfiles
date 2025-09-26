{ pkgs, ... }:

let
  wzip = pkgs.writeShellScriptBin "wzip" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$#" -lt 2 ]; then
      echo "Usage: wzip <output_zip_name.zip> <file_or_dir> [...]"
      exit 1
    fi

    OUT="$1"
    shift

    '${pkgs.p7zip}/bin/7z' a -tzip -mx=9 -mcu "$OUT" "$@" -xr!*.DS_Store -xr!__MACOSX

    echo "Created ZIP: $OUT"
  '';
in
{
  home.packages = [ wzip ];
}
