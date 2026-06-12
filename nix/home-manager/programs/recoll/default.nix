{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:

let
  dataDir =
    if isDarwin then
      "${config.home.homeDirectory}/GoogleDrive/local_data_dir"
    else
      "${config.home.homeDirectory}/Nextcloud";

  recollHelperPath =
    if isDarwin then
      "recollhelperpath = ${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/opt/homebrew/bin"
    else
      "";
in
{
  home.packages = [ pkgs.recoll ];

  xdg.configFile."recoll/recoll.conf" = {
    text = ''
      topdirs = ${dataDir}/book ${dataDir}/orgnotes ${dataDir}/documents ${dataDir}/zotero
      ${recollHelperPath}
      noContentSuffixes+ = .bib .zip .iso .img
      underscoreasletter = true
      backslashasletter = true
      orgmodesubdocs = true
      indexallfilenames = true
      indexStoreDocText = true
      idxabsmlen = 2000
    '';
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # recoll
    export RECOLL_CONFDIR="${config.xdg.configHome}/recoll"
    export RECOLL_DATADIR="${pkgs.recoll}/share/recoll"
    export PYTHONPATH="${pkgs.recoll}/lib/python3.13/site-packages:${pkgs.recoll}/lib/python3.13/site-packages/recoll:''${PYTHONPATH:-}"
  '';
}
