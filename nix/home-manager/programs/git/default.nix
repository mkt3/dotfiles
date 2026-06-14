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
      format = "openpgp";
      signByDefault = true;
      key = "AB1322B5A83A7EA4FE4AF3BF8E8400751C7F4E16";
    };

    ignores = [
      ".DS_Store"
      ".direnv"
      ".venv"
    ];
  };
}
