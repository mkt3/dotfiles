{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --24-bit-color=never -n";
        };
      };
    };
  };
}
