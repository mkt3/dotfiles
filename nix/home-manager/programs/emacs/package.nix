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
        sha256 = "nl0+JqjTiNOgALaX1YJ2lkXKk61Ze0ETdE3rpLiai54=";
      })
      # Make Emacs aware of OS-level light/dark mode
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/system-appearance.patch";
        sha256 = "Uyg1A9te0oh+nXM7qq+A8sgQ5mjngumIvaWFWgsevrQ=";
      })
      # Enable rounded window with no decoration
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
        sha256 = "yUMKHq2B4xOz0od/9vgET7KUQe7MfMQgAFFdfI7GOA8=";
      })
      # Fix crashes when scrolling on macOS
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/fix-ns-scroll-crash.patch";
        sha256 = "MlC/bkXNyz9MvArOLS0yAEZDMcv7NGE5gFVOMexF/mw=";
      })
    ];
  })
else if isGUI then
  pkgs.emacs31-pgtk
else
  pkgs.emacs31-nox
