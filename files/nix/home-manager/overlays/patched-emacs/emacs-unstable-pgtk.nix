final: prev: {
  patched-emacs = prev.emacs-unstable-pgtk.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./personal_diff.patch ];
  });
}
