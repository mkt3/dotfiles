final: prev: {
  patched-emacs = prev.emacs-pgtk.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./personal_diff.patch
      ];
  });
}
