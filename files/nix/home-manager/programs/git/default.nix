{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Makoto Morinaga";
        email = "makoto@mkt3.dev";
      };

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
        precomposeunicode = true;
        quotepath = false;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };

    signing = {
      signByDefault = true;
      key = null;
    };

    ignores = [
      ".DS_Store"
      ".envrc"
      ".direnv"
      ".venv"
    ];
  };
}
