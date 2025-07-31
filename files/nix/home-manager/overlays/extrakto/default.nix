final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    extrakto = prev.tmuxPlugins.extrakto.overrideAttrs (oldAttrs: {
      postInstall = ''
        patchShebangs extrakto.py extrakto_plugin.py

        wrapProgram $target/scripts/open.sh \
          --prefix PATH : ${
            let
              clipboardTools =
                if prev.stdenv.isDarwin then
                  with prev;
                  lib.makeBinPath [
                    fzf
                  ]
                else
                  with prev;
                  lib.makeBinPath [
                    fzf
                    wl-clipboard
                  ];
            in
            clipboardTools
          }
      '';
    });
  };
}
