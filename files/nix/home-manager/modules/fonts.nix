{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = pkgs.lib.mkIf (pkgs.stdenv.isLinux) {
    serif = [
      "Noto Serif"
      "Noto Color Emoji"
    ];
    sansSerif = [
      "Noto Sans CJK JP"
      "Noto Sans"
      "Noto Color Emoji"
    ];
    monospace = [
      "Noto Sans Mono"
      "Noto Color Emoji"
    ];
    emoji = [ "Noto Color Emoji" ];
  };

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerdfonts
    plemoljp-nf
  ];
}
