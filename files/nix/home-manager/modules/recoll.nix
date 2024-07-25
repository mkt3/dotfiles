{ pkgs, ... }:
{
  home.packages = [
    pkgs.recoll
  ];

  xdg.configFile."recoll/recoll.conf" = {
    text = ''
      topdirs = ~/Nextcloud/book ~/Nextcloud/orgnotes ~/Nextcloud/documents ~/Nextcloud/zotero
      recollhelperpath = /usr/local/bin
      noContentSuffixes+ = .bib
    '';
  };
}
