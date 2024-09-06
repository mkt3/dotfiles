{ pkgs, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).meetingbar;
  lib = pkgs.lib;
  stdenvNoCC = pkgs.stdenvNoCC;
  hdiutil = "/usr/bin/hdiutil";
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  preferLocalBuild = true;

  sourceRoot = "MeetingBar.app";

  unpackPhase = ''
    ${hdiutil} attach -readonly -mountpoint mnt $src
    cp -r "mnt/$sourceRoot" .
    ${hdiutil} detach -force mnt
  '';

  installPhase = ''
    runHook preInstall

    ${hdiutil} attach $src
    mkdir -p $out/Applications/
    mkdir -p "$out/Applications/$sourceRoot"
    cp -R . "$out/Applications/$sourceRoot"

    runHook postInstall
  '';

  meta = with lib; {
    description = "MeetingBar is a menu-bar app for your calendar meetings";
    homepage = "https://github.com/leits/MeetingBar";
    changelog = "https://github.com/nikitabobko/AeroSpace/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
