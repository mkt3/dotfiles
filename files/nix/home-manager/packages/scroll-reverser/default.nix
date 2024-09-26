{ pkgs, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).scroll-reverser;
  lib = pkgs.lib;
  stdenvNoCC = pkgs.stdenvNoCC;
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ pkgs.unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Scroll Reverser.app"
    cp -R . "$out/Applications/Scroll Reverser.app"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reverses the direction of scrolling on macOS, with independent settings for trackpads and mice";
    homepage = "https://github.com/pilotmoon/Scroll-Reverser";
    changelog = "https://github.com/pilotmoon/Scroll-Reverser/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
