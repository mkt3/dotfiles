{ pkgs, isGUI, isCUI, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
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

  home.file.".gnupg/gpg-agent.conf" = {
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

  # home.file.".gtkrc-2" = lib.mkIf (isLinux && isGUI) {
  #   text = "gtk-im-module=\"fcitx\"";
  #   gtk-cursor-theme-name="Nordzy-cursors"
  # };

  # home.file.".gtk-3.0/settings.ini" = lib.mkIf (isLinux && isGUI) {
  #   text = ''
  #        [Settings]
  #        gtk-im-module=fcitx
  #        gtk-application-prefer-dark-theme=true
  #        gtk-cursor-theme-name=Nordzy-cursors
  #        '';
  # };
  # home.file.".gtk-4.0/settings.ini" = lib.mkIf (isLinux && isGUI) {
  #   text = ''
  #        [Settings]
  #        gtk-im-module=fcitx
  #        gtk-cursor-theme-name=Nordzy-cursors
  #        '';
  # };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.nordzy-icon-theme;
      name = "Nordzy";
    };
  };
}
