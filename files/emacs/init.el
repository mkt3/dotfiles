(setq vc-follow-symlinks t)

;; Silence compiler warnings
(setq native-comp-async-report-warnings-errors 'silent)

(require 'org)
(org-babel-load-file
 (expand-file-name "README.org" user-emacs-directory))
