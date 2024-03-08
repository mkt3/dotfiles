{ pkgs, isGUI, isCUI, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  lib = pkgs.lib;
in
{
  services.gpg-agent = lib.mkIf (isLinux && isGUI) {
    enable = true;
    maxCacheTtl = 60480000;
    maxCacheTtlSsh = 60480000;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
  };

  home.file.".gnupg/gpg-agent.conf" = lib.mkIf (!isLinux || isCUI) {
    text = ''
         max-cache-ttl 60480000
         default-cache-ttl 60480000
         max-cache-ttl-ssh 60480000
         default-cache-ttl-ssh 60480000
         '' + (if isDarwin then "\npinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac" else "");
  };

  home.file.".gnupg/gpg.conf" = lib.mkIf (isLinux && isCUI) {
    text = "no-autostart";
  };
}
