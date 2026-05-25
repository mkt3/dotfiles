{ pkgs, lib, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).omniwm;
  stdenvNoCC = pkgs.stdenvNoCC;
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  preferLocalBuild = true;

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = "OmniWM.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/
    mkdir -p "$out/Applications/$sourceRoot"
    mkdir -p $out/bin
    cp -R . "$out/Applications/$sourceRoot"
    ln -s "$out/Applications/$sourceRoot/Contents/MacOS/omniwmctl" "$out/bin/omniwmctl"

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS tiling window manager inspired by Niri and Hyprland";
    homepage = "https://github.com/BarutSRB/OmniWM";
    changelog = "https://github.com/BarutSRB/OmniWM/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
