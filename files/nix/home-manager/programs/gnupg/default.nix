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
{
  # services.gpg-agent = lib.mkIf (isLinux && isGUI) {
  #   enable = true;
  #   maxCacheTtl = 60480000;
  #   maxCacheTtlSsh = 60480000;
  #   defaultCacheTtl = 60480000;
  #   defaultCacheTtlSsh = 60480000;
  # };

  home.packages = lib.optionals (isNixOS || isDarwin) [ pkgs.gnupg ];

  programs.zsh.envExtra = lib.mkAfter (
    lib.concatStringsSep "\n" (
      [
        "# GnuPG"
        "# default value is ~/.gnupg. If use non-default GnuPG Home directory, need to edit all socket files."
        "export GNUPGHOME=\"${config.home.homeDirectory}/.gnupg\""
        "export GPG_TTY=$(tty)"
        "export SSH_AGENT_PID=\"\""
      ]
      ++ lib.optionals isLinux [
        "export SSH_AUTH_SOCK=\"\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh\""
      ]
      ++ lib.optionals isDarwin [
        ''export SSH_AUTH_SOCK="${config.home.homeDirectory}/.gnupg/S.gpg-agent.ssh"''
      ]
    )
    + "\n"
  );

  home.file =
    {
      ".gnupg/gpg-agent.conf" = {
        text = lib.mkMerge (
          [
            "max-cache-ttl 60480000"
            "default-cache-ttl 60480000"
            "max-cache-ttl-ssh 60480000"
            "default-cache-ttl-ssh 60480000"
          ]
          ++ lib.optionals isDarwin [
            "pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
          ]
        );
      };
    }
    // lib.optionalAttrs (isLinux && !isNixOS && !isGUI) {
      ".gnupg/gpg.conf" = {
        text = "no-autostart";
        onChange = "/usr/bin/systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket";
      };
    };
}
