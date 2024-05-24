final: prev: {
  patched-emacs = prev.emacs-unstable-nox.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./personal_diff.patch
      ];
  });
}
