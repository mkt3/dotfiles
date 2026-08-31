{
  pkgs,
  config,
  lib,
  isLinux,
  isDarwin,
  isGUI,
  ...
}:
let
  emacsPackage = import ./package.nix { inherit pkgs isDarwin isGUI; };
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  elpaVersion = source: "${builtins.replaceStrings [ "-" ] [ "" ] source.date}.0";
  configuredEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = emacsPackage;
    config = ./README.org;
    # README.org has ordinary Org Babel source blocks without :tangle headers.
    alwaysTangle = true;
    # Home Manager installs the generated configuration below.
    defaultInitFile = false;
    override = _final: prev: {
      nerd-icons-dired = prev.nerd-icons-dired.overrideAttrs (_old: {
        inherit (sources.nerd-icons-dired) src;
        version = elpaVersion sources.nerd-icons-dired;
      });
      just-ts-mode = prev.just-ts-mode.overrideAttrs (_old: {
        inherit (sources.just-ts-mode) src;
        # melpa2nix requires an ELPA-compatible version, not a Git SHA.
        version = elpaVersion sources.just-ts-mode;
      });
      ox-hugo = prev.ox-hugo.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./patches/ox-hugo-tangle-filepath.patch ];
      });
      typst-ts-mode = prev.typst-ts-mode.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          patch -p1 \
            -d "$out/share/emacs/site-lisp/elpa/typst-ts-mode-${old.version}" \
            < ${./patches/typst-ts-mode-compilation-autoload.patch}
        '';
      });
    };
    # These are not ELPA packages declared with :ensure in README.org.
    extraEmacsPackages =
      epkgs:
      [
        (epkgs.treesit-grammars.with-grammars (
          p: with p; [
            tree-sitter-bash
            tree-sitter-cuda
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-c-sharp
            tree-sitter-cmake
            tree-sitter-css
            tree-sitter-scss
            tree-sitter-sql
            tree-sitter-dockerfile
            tree-sitter-elisp
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-just
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-latex
            tree-sitter-bibtex
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-python
            tree-sitter-ruby
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-typst
            tree-sitter-yaml
            tree-sitter-kdl
          ]
        ))
        epkgs.ghostel
      ]
      ++ lib.optionals isGUI [
        epkgs.pdf-tools
        epkgs.mu4e
      ];
  };
  tangledEmacsConfig = pkgs.runCommand "emacs-config.el" { } ''
    ${emacsPackage}/bin/emacs --batch -Q \
      --eval '(progn
        (require (quote org))
        (require (quote ob-tangle))
        (org-babel-tangle-file
          "${./README.org}"
          (getenv "out")
          "emacs-lisp"))'
    test -s "$out"
  '';
  sharedSKKDictionary = "${config.home.homeDirectory}/workspace/ghq/github.com/mkt3/skk-dict/SKK-JISYO.shared";
in
{
  home.packages = [ configuredEmacs ];

  xdg.desktopEntries = lib.optionalAttrs (isGUI && isLinux) {
    emacs = {
      name = "Emacs";
      genericName = "Text Editor";
      comment = "Edit text";

      exec = "env COLORTERM=truecolor env GTK_IM_MODULE=xim emacs %F";

      icon = "emacs";
      type = "Application";
      terminal = false;
      categories = [
        "Development"
        "TextEditor"
      ];

      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
  };

  xdg.configFile = {
    "emacs/README.org".source = ./README.org;
    "emacs/config.el".source = tangledEmacsConfig;
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/init.el".source = ./init.el;
    "emacs/templates".source = ./templates;
    "emacs/ddskk.d/init.el".source = ./ddskk.d/init.el;

    "zsh/defer.zsh" = {
      text = lib.mkMerge (
        [
          ''
            if [[ "$TERM" == "dumb" ]]; then
              unsetopt zle
              unsetopt prompt_cr
              unsetopt prompt_subst
              unfunction precmd
              unfunction preexec
              PS1='$ '
            fi
          ''
        ]
        ++ lib.optionals isDarwin [
          ''
            alias emacs="${config.home.homeDirectory}/Applications/Home\ Manager\ Apps/Emacs.app/Contents/MacOS/Emacs -nw"
          ''
        ]
        ++ lib.optionals isLinux [
          ''
            if [[ -f "/usr/lib/x86_64-linux-gnu/libnss_sss.so.2" ]]; then
              alias emacs="LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_sss.so.2 emacs -nw"
            else
              alias emacs="emacs -nw"
            fi
          ''
        ]
      );
    };
  }
  // {
    "emacs/SKK-JISYO.shared".source = config.lib.file.mkOutOfStoreSymlink sharedSKKDictionary;
  };

  programs.zsh.envExtra = lib.mkAfter (
    lib.optionalString isGUI ''
      # password store
      export PASSWORD_STORE_DIR="${config.home.homeDirectory}/Nextcloud/personal_config/password-store"
    ''
  );

}
