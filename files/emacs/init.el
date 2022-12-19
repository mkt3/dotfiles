(defconst my-saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq vc-follow-symlinks t)

;; Silence compiler warnings
(setq native-comp-async-report-warnings-errors 'silent)

(native-compile-async "~/.config/emacs/ddskk.d/init.el")

(require 'org)
(org-babel-load-file
 (expand-file-name "README.org" user-emacs-directory))

(setq file-name-handler-alist my-saved-file-name-handler-alist)
