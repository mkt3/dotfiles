;;====================================================================
;; basic info
;;====================================================================
;(package-initialize)

(when load-file-name
    (setq user-emacs-directory (file-name-directory load-file-name)))

(setq load-path (append '("~/.emacs.d/private-conf") load-path))

;;====================================================================
;; path
;;====================================================================
(let ((path-str
           (replace-regexp-in-string
                       "\n+$" "" (shell-command-to-string "echo $PATH"))))
     (setenv "PATH" path-str)
          (setq exec-path (nconc (split-string path-str ":") exec-path)))

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

(global-set-key "\C-x," 'reload-dotemacs)

