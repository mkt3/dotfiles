final: prev:
let
  removeRequiredFragment =
    phase: fragment: value:
    if prev.lib.hasInfix fragment value then
      prev.lib.replaceStrings [ fragment ] [ "" ] value
    else
      throw "recoll overlay: expected Darwin fragment was not found in ${phase}; review the nixpkgs Recoll definition";

  darwinAppInstall = ''
    mkdir $out/Applications
    mv $out/bin/recoll.app $out/Applications
  '';

  darwinAppSymlink = ''
    ln -s ../Applications/recoll.app/Contents/MacOS/recoll $out/bin/recoll
  '';
in
{
  recoll =
    if prev.stdenv.hostPlatform.isDarwin then
      prev.recoll.overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dx11mon=false" ];
        NIX_LDFLAGS = (old.NIX_LDFLAGS or "") + " -framework IOKit";
        postInstall = removeRequiredFragment "postInstall" darwinAppInstall (old.postInstall or "");
        postFixup = removeRequiredFragment "postFixup" darwinAppSymlink (old.postFixup or "");
      })
    else
      prev.recoll;
}
