{ pkgs, lib, home, ... }:
{
  services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    maxCacheTtl = 60480000;
    maxCacheTtlSsh = 60480000;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
  };

  home.file.".gnupg/gpg-agent.conf" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
         max-cache-ttl 60480000
         default-cache-ttl 60480000
         max-cache-ttl-ssh 60480000
         default-cache-ttl-ssh 60480000
         pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
         '';
  };
}
