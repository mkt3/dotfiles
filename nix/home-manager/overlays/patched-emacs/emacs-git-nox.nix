final: prev: {
  patched-emacs = prev.emacs-git-nox.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./personal_diff.patch
    ];
  });
}
