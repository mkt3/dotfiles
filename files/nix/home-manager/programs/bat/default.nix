{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      pager = "less -F -R";
      italic-text = "always";
    };

    extraPackages = with pkgs.bat-extras; [ batman batgrep ];
  };
}
