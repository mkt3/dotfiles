{
  pkgs,
  isGUI,
  config,
  ...
}:
let
  isNixOS =
    pkgs.stdenv.hostPlatform.isLinux && (builtins.match ".*nixos.*" (pkgs.stdenv.system) != null);
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  lib = pkgs.lib;
in
{
  # services.gpg-agent = lib.mkIf (isLinux && isGUI) {
  #   enable = true;
  #   maxCacheTtl = 60480000;
  #   maxCacheTtlSsh = 60480000;
  #   defaultCacheTtl = 60480000;
  #   defaultCacheTtlSsh = 60480000;
  # };

  home.packages = lib.mkIf (isNixOS || isDarwin) [ pkgs.gnupg ];

  home.file.".zshenv" = {
    text = lib.mkMerge (
      [
        "# GnuPG"
        "# default value is ~/.gnupg. If use non-default GnuPG Home directory, need to edit all socket files."
        "export GNUPGHOME=\"${config.home.homeDirectory}/.gnupg\""
        "export GPG_TTY=$(tty)"
        "export SSH_AGENT_PID=\"\""

      ]
      ++ lib.optionals isLinux [
        ''export SSH_AUTH_SOCK="${config.xdg.runtimeDir}/gnupg/S.gpg-agent.ssh"''
      ]
      ++ lib.optionals isDarwin [
        ''export SSH_AUTH_SOCK="${config.home.homeDirectory}/.gnupg/S.gpg-agent.ssh"''
      ]
    );
  };

  home.file.".gnupg/gpg-agent.conf" = {
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

  home.file.".gnupg/gpg.conf" = lib.mkIf (isLinux && !isNixOS && !isGUI) {
    text = "no-autostart";
    onChange = "/usr/bin/systemctl --user mask gpg-agent.service gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket";
  };
}
