final: prev:
let
  isLinux = prev.stdenv.hostPlatform.isLinux;
  meta = prev.vlc.meta // {
    description = "Cross-platform media player and streaming server";
    platforms = prev.vlc.meta.platforms ++ prev.lib.platforms.darwin;
  };
in
{
  vlc =
    if isLinux then
      prev.vlc.overrideAttrs (old: {
        inherit meta;
      })
    else
      let
        source =
          (import ../../../_sources/generated.nix {
            inherit (prev)
              fetchgit
              fetchurl
              fetchFromGitHub
              dockerTools
              ;
          }).vlc;
      in
      prev.stdenvNoCC.mkDerivation {
        pname = "vlc";
        inherit (source) version src;

        preferLocalBuild = true;

        nativeBuildInputs = [ prev.undmg ];

        sourceRoot = "VLC.app";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/Applications/VLC.app
          cp -R . $out/Applications/VLC.app

          runHook postInstall
        '';

        inherit meta;
      };
}
