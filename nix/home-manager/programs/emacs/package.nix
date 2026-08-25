{
  pkgs,
  isDarwin,
  isGUI,
}:

if isDarwin then
  pkgs.emacs31.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Fix limited x-colors when NS Emacs is dumped in a headless environment
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/fix-ns-x-colors.patch";
        sha256 = "oe3DFgEXwp0cZJl+ufWqTonaeWSliikTRsVDNbcy4Yw=";
      })
      # Make Emacs aware of OS-level light/dark mode
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/system-appearance.patch";
        sha256 = "4+2U+4+2tpuaThNJfZOjy1JPnneGcsoge9r+WpgNDko=";
      })
      # Enable rounded window with no decoration
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
        sha256 = "KCMEvJzN1OkwFYoMLpZghvdeoO1Ckcxk3Mo19YAf850=";
      })
      # Fix crashes when scrolling on macOS
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/fix-ns-scroll-crash.patch";
        sha256 = "syC9un5Vy1+bmBWIc+TEwTCM/nfPIxd4IhWYdEfP4qE=";
      })
    ];
  })
else if isGUI then
  pkgs.emacs31-pgtk
else
  pkgs.emacs31-nox
