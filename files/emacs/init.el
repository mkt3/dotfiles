(setq vc-follow-symlinks t)

(require 'org)
(org-babel-load-file
 (expand-file-name "README.org" user-emacs-directory))
