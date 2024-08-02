{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.patched-emacs;
    extraPackages = epkgs: [
      epkgs.pdf-tools
      epkgs.mu4e
      epkgs.jinx
      epkgs.treesit-grammars.with-all-grammars
    ];
  };
}
