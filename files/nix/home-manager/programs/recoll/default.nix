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

  recollHelperPath = if isDarwin then "recollhelperpath = /opt/homebrew/bin" else "";

  recollPathEnv =
    if isDarwin then
      ''
        export PATH="''${PATH}:/Applications/Recoll.app/Contents/MacOS"
      ''
    else
      "";
in
{
  home.packages = lib.optionals (!isDarwin) [ pkgs.recoll ];

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
    ${recollPathEnv}
  '';
}
