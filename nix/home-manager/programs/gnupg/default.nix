{
  pkgs,
  lib,
  isLinux,
  isDarwin,
  isNixOS,
  isGUI,
  config,
  ...
}:
let
  enableLocalAgent = isDarwin || isNixOS || isGUI;
  disableLocalAgent = isLinux && !enableLocalAgent;
  gpgAgentUnits = [
    "gpg-agent.service"
    "gpg-agent.socket"
    "gpg-agent-ssh.socket"
    "gpg-agent-extra.socket"
    "gpg-agent-browser.socket"
  ];
in
{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./keys/mkt3.github.gpg.asc;
        trust = "ultimate";
      }
    ];
    settings = lib.optionalAttrs disableLocalAgent {
      no-autostart = true;
    };
  };

  services.gpg-agent = lib.mkIf enableLocalAgent {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    noAllowExternalCache = true;
    pinentry.package =
      if isDarwin then
        pkgs.pinentry_mac
      else if isGUI then
        pkgs.pinentry-qt
      else
        pkgs.pinentry-curses;
  };

  home.packages = lib.optionals (isNixOS || isDarwin) [ pkgs.gnupg ];

  programs.zsh.envExtra = lib.mkAfter (
    lib.concatStringsSep "\n" ([
      "# GnuPG"
      "# default value is ~/.gnupg. If use non-default GnuPG Home directory, need to edit all socket files."
      "export GNUPGHOME=\"${config.home.homeDirectory}/.gnupg\""
    ])
    + "\n"
  );

  home.activation = lib.optionalAttrs disableLocalAgent {
    maskGpgAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x /usr/bin/systemctl ] && /usr/bin/systemctl --user show-environment >/dev/null 2>&1; then
        /usr/bin/systemctl --user mask --now ${lib.escapeShellArgs gpgAgentUnits}
      fi
    '';
  };
}
