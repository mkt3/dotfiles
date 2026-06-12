final: prev:
{
  recoll =
    if prev.stdenv.hostPlatform.isDarwin then
      prev.recoll.overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dx11mon=false" ];
        NIX_LDFLAGS = (old.NIX_LDFLAGS or "") + " -framework IOKit";
        postInstall = prev.lib.replaceStrings
          [
            ''
              mkdir $out/Applications
              mv $out/bin/recoll.app $out/Applications
            ''
          ]
          [ "" ]
          (old.postInstall or "");
        postFixup = "";
      })
    else
      prev.recoll;
}
