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
    enableSshSupport = true;
    maxCacheTtl = 60480000;
    maxCacheTtlSsh = 60480000;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    pinentry.package = lib.mkIf isDarwin pkgs.pinentry_mac;
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
      /usr/bin/systemctl --user mask ${lib.escapeShellArgs gpgAgentUnits}
    '';
  };
}
