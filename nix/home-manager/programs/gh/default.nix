{ ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      alias = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  # home.file.".zshenv".text = ''
  #   # github cli
  #   export NIX_CONFIG="access-tokens = github.com=$(gh auth token)"
  # '';
}
