{ pkgs, ... }:
{
  home.packages = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) [ pkgs.recoll ];

  xdg.configFile."recoll/recoll.conf" = {
    text = ''
      topdirs = ~/Nextcloud/book ~/Nextcloud/orgnotes ~/Nextcloud/documents ~/Nextcloud/zotero
      recollhelperpath = /opt/homebrew/bin
      noContentSuffixes+ = .bib
    '';
  };

  home.file.".zshenv".text = ''
    # recoll
    export RECOLL_CONFDIR="''${XDG_CONFIG_HOME}/recoll"
    export PATH="''${PATH}:/Applications/Recoll.app/Contents/MacOS"
  '';
}
