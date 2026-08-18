{ pkgs, lib, ... }:
let
  source = (pkgs.callPackage ../../../_sources/generated.nix { }).chatgpt;
in
{
  home.packages = [
    (pkgs.stdenvNoCC.mkDerivation {
      inherit (source) pname version src;

      nativeBuildInputs = [ pkgs.libarchive ];
      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/Applications" "$out/bin"
        bsdtar -xf "$src" -C "$out/Applications"
        ln -s "$out/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" "$out/bin/ChatGPT"

        runHook postInstall
      '';

      meta = with lib; {
        description = "OpenAI's official ChatGPT desktop app";
        homepage = "https://chatgpt.com/";
        license = licenses.unfree;
        mainProgram = "ChatGPT";
        platforms = platforms.darwin;
        sourceProvenance = [ sourceTypes.binaryNativeCode ];
      };
    })
  ];
}
