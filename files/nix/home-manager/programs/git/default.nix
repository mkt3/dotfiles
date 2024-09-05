{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Makoto Morinaga";
    userEmail = "makoto@mkt3.dev";

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
    };

    signing = {
      signByDefault = true;
      key = null;
    };

    ignores = [
      ".DS_Store"
      ".envrc"
      ".mise.toml"
      ".venv"
    ];

    extraConfig = {
      pull = {
        rebase = false;
      };
      url = {
        "git@github.com:" = {
          pushInsteadOf = "https://github.com";
        };
      };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        prune = true;
      };
      core = {
        ignorecase = false;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };
}
