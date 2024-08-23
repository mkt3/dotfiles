{
  pkgs,
  isGUI,
  isCLI,
  ...
}:
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

  # gpg
  home.file.".gnupg/gpg-agent.conf" = {
    text =
      ''
        max-cache-ttl 60480000
        default-cache-ttl 60480000
        max-cache-ttl-ssh 60480000
        default-cache-ttl-ssh 60480000
      ''
      + (
        if isDarwin then
          "\npinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
        else
          ""
      );
  };

  home.file.".gnupg/gpg.conf" = lib.mkIf (isLinux && isCLI) { text = "no-autostart"; };

  # docker
  xdg.configFile."docker.config.json" = {
    text = ''
      {
       	"auths": {},
      	"detachKeys": "ctrl-\\",
      	"currentContext": "rootless"
      }
    '';
  };

  # libskk
  xdg.configFile."libskk/rules/StickyShift/meta.json" = lib.mkIf (isLinux && isGUI) {
    text = ''
      {
        "name": "StickyShift",
        "description": "Typing rule, support sticky key"
      }
    '';
  };

  xdg.configFile."libskk/rules/StickyShift/keymap/hiragana.json" = lib.mkIf (isLinux && isGUI) {
    text = ''
      {
        "include": [
          "default/hiragana"
        ],
        "define": {
          "keymap": {
            ";": "start-preedit-no-delete"
          }
        }
      }
    '';
  };
  xdg.configFile."libskk/rules/StickyShift/keymap/katakana.json" = lib.mkIf (isLinux && isGUI) {
    text = ''
      {
        "include": [
          "default/katakana"
        ],
        "define": {
          "keymap": {
            ";": "start-preedit-no-delete"
          }
        }
      }
    '';
  };
}
