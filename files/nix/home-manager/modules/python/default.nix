{ ... }:
{
  programs.matplotlib = {
    enable = true;
    config = {
      "font.serif:Noto" = "Sans CJK JP";
      "font.sans-serif" = "Noto Sans CJK JP";
    };
  };
}
