final: prev:
let
  isLinux = prev.stdenv.hostPlatform.isLinux;
  meta = prev.vivaldi.meta // {
    description = "A Browser for our Friends powerful and personal";
    platforms = prev.vivaldi.meta.platforms ++ prev.lib.platforms.darwin;
  };
in
{
  vivaldi =
    if isLinux then
      prev.vivaldi.overrideAttrs (old: {
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
          }).vivaldi-darwin;
      in
      prev.stdenvNoCC.mkDerivation {
        pname = "vivaldi";
        inherit (source) version src;

        preferLocalBuild = true;

        nativeBuildInputs = [ prev.undmg ];

        sourceRoot = "Vivaldi.app";

        installPhase = ''
          runHook preInstall

          mkdir -p $out/Applications/Vivaldi.app
          cp -R . $out/Applications/Vivaldi.app

          runHook postInstall
        '';

        inherit meta;
      };
}
