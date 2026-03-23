{ ... }:
{
  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      incremental-search = "true";

      zoom-step = 20;
      scroll-step = 80;
      statusbar-home-tilde = "true";
      window-title-basename = "true";
      guioptions = "cshv";
    };
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      K = "zoom in";
      J = "zoom out";
      D = "toggle_page_mode";
    };

    extraConfig = "unmap <C-j>";
  };
}
