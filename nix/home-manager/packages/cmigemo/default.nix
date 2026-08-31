{
  lib,
  callPackage,
  stdenv,
  cmake,
  curl,
  gzip,
  iconv,
  perl,
  skkDictionaries,
}:

let
  source = (callPackage ../../../_sources/generated.nix { }).cmigemo;
in
stdenv.mkDerivation {
  inherit (source) pname src;
  version = lib.removePrefix "v" source.version;

  nativeBuildInputs = [
    cmake
    curl
    gzip
    iconv
    perl
  ];

  preConfigure = ''
    mkdir -p build/dict
    cp ${skkDictionaries.l}/share/skk/SKK-JISYO.L build/dict/SKK-JISYO.L
  '';

  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  meta = {
    description = "Tool that supports Japanese incremental search with Romaji";
    homepage = "https://github.com/koron/cmigemo";
    license = lib.licenses.mit;
    mainProgram = "cmigemo";
    platforms = lib.platforms.all;
  };
}
