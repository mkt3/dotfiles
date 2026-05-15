{
  pkgs,
  isDarwin,
  isGUI,
}:

if isDarwin then
  pkgs.emacs.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./org-link-nov-relative-path-emacs-30.2.patch
      # Fix OS window role (needed for window managers like yabai)
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })
      # Make Emacs aware of OS-level light/dark mode
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
        sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
      })
      # Enable rounded window with no decoration
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
        sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
      })
      # Fix severe scrolling lag on macOS Tahoe
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/fix-macos-tahoe-scrolling.patch";
        sha256 = "Hf9oZ5ImBnxTLa6yS02UDzBEgJEGAwNq/svJ3S35uKw=";
      })
      # Fix limited x-colors when NS Emacs is dumped in a headless environment
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/fix-ns-x-colors.patch";
        sha256 = "oe3DFgEXwp0cZJl+ufWqTonaeWSliikTRsVDNbcy4Yw=";
      })
    ];
  })
else if isGUI then
  (pkgs.emacs-git-pgtk.override { withXwidgets = true; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./org-link-nov-relative-path-emacs-git.patch
      ./xwidget.patch
    ];
  })
else
  pkgs.emacs-nox
