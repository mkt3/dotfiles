{ config, ... }:
{
  programs.ruff = {
    enable = true;
    settings = {
      # cache-dir
      cache-dir = "${config.xdg.cacheHome}/ruff";
      # Exclude a variety of commonly ignored directories.
      exclude = [
        ".bzr"
        ".direnv"
        ".eggs"
        ".git"
        ".git-rewrite"
        ".hg"
        ".mypy_cache"
        ".nox"
        ".pants.d"
        ".pytype"
        ".ruff_cache"
        ".svn"
        ".tox"
        ".venv"
        "__pypackages__"
        "_build"
        "buck-out"
        "build"
        "dist"
        "node_modules"
        "venv"
      ];
      line-length = 300;
      indent-width = 4;

      lint = {
        select = [ "ALL" ];
        ignore = [
          "E501"
          "PGH"
          "DJ"
          "D"
          "T20"
          "ERA"
          "C90"
          "ANN101"
          "FA102"
          "RUF001"
          "PLR0915"
          "S101"
          "S311"
          "S104"
        ];
        fixable = [
          "I"
          "SIM118"
        ];
        unfixable = [ ];
      };

      format = {
        # Like Black, use double quotes for strings.
        quote-style = "double";
        # Like Black, indent with spaces, rather than tabs.
        indent-style = "space";
        # Like Black, respect magic trailing commas.
        skip-magic-trailing-comma = false;
        # Like Black, automatically detect the appropriate line ending.
        line-ending = "auto";
      };
    };
  };
}
