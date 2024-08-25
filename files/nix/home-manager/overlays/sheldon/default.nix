final: prev: {
  sheldon = prev.sheldon.overrideAttrs (old: rec {
    src = prev.fetchFromGitHub {
      owner = "rossmacarthur";
      version = "0.8.0";
      repo = "sheldon";
      rev = "9836ef98ca2b44f781deafb409028d4dda7fef17";
      sha256 = "eyfIPO1yXvb+0SeAx+F6/z5iDUA2GfWOiElfjn6abJM=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (
      prev.lib.const {
        name = "sheldon-0.8.0-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-+yTX1wUfVVjsM42X0QliL+0xbzTPheADZibPh/5Czh8=";
      }
    );
  });
}
