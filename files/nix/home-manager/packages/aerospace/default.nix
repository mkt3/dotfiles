{ pkgs, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).aerospace;
  lib = pkgs.lib;
  stdenvNoCC = pkgs.stdenvNoCC;
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ pkgs.unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv AeroSpace.app $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "AeroSpace is an i3-like tiling window manager for macOS";
    homepage = "https://github.com/nikitabobko/AeroSpace";
    changelog = "https://github.com/nikitabobko/AeroSpace/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
