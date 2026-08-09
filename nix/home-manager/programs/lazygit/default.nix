{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git = {
        diffRenderers = [
          {
            command = "delta --dark --paging=never --24-bit-color=auto -n";
            colorArg = "always";
          }
        ];
      };
    };
  };
}
