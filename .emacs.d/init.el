;;====================================================================
;; package管理(straight.el)
;;====================================================================
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; packeges
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;====================================================================
;; path
;;====================================================================
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(setq load-path (append '("~/.emacs.d/private-conf") load-path))


;;====================================================================
;; init-loader
;;====================================================================
(use-package init-loader
  :config
  (init-loader-load (locate-user-emacs-file "conf")))

;;====================================================================
;; reload .emacs
;;====================================================================
(defun reload-dotemacs()
  "Reload the .emacs file"
  (interactive)
  (load-file (locate-user-emacs-file "init.el"))
  )

(bind-key* "C-x ," 'reload-dotemacs)

