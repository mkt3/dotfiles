final: prev: {
  patched-emacs = prev.emacs-git.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./personal_diff.patch
        # Make Emacs aware of OS-level light/dark mode
        (final.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
          sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
        })
      ];
  });
}
