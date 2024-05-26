{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      plemoljp-nf
    ];
  };
}
