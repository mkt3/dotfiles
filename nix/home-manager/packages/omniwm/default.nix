{ pkgs, lib, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).omniwm;
  stdenvNoCC = pkgs.stdenvNoCC;
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  preferLocalBuild = true;

  dontUnpack = true;
  strictDeps = true;

  nativeBuildInputs = [ pkgs.libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    bsdtar -xf "$src" -C "$out/Applications"
    ln -s "$out/Applications/OmniWM.app/Contents/MacOS/OmniWM" "$out/bin/OmniWM"
    cp "$out/Applications/OmniWM.app/Contents/MacOS/omniwmctl" "$out/bin/omniwmctl"

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS tiling window manager inspired by Niri and Hyprland";
    longDescription = ''
      OmniWM is a macOS tiling window manager that is developer signed and
      notarized. It features Niri-style scrolling columns and Hyprland-style
      dwindle layouts, with a built-in quake terminal, command palette,
      overview mode, and more.
    '';
    homepage = "https://github.com/BarutSRB/OmniWM";
    changelog = "https://github.com/BarutSRB/OmniWM/releases/tag/${version}";
    license = licenses.gpl2Only;
    mainProgram = "OmniWM";
    maintainers = [ ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
