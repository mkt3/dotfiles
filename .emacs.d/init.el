;;====================================================================
;; basic info 
;;====================================================================
;(package-initialize)

(when load-file-name
    (setq user-emacs-directory (file-name-directory load-file-name)))

(setq load-path (append '("~/.emacsd/private-conf") load-path))
(load "proxy" t)

;;====================================================================
;; path 
;;====================================================================
(let ((path-str
           (replace-regexp-in-string
                       "\n+$" "" (shell-command-to-string "echo $PATH"))))
     (setenv "PATH" path-str)
          (setq exec-path (nconc (split-string path-str ":") exec-path)))

;;====================================================================
;; package管理(el-get)
;;====================================================================
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))

(unless (require 'el-get nil 'noerror)
   (shell-command-to-string (concat "git clone https://github.com/dimitri/el-get.git " (locate-user-emacs-file "el-get/el-get" )))
  (require 'el-get))

;; packeges
(el-get-bundle init-loader)
(el-get-bundle elpa:color-theme)
(el-get-bundle elpa:color-theme-solarized)
(el-get-bundle ddskk)
(el-get-bundle avy)
(el-get-bundle ace-isearch)
(el-get-bundle migemo)
(el-get-bundle helm)
(el-get-bundle helm-swoop)
(el-get-bundle yasnippet)
(el-get-bundle popup)
(el-get-bundle auto-complete)
(el-get-bundle sequential-command)
(el-get-bundle elpa:shell-pop)
(el-get-bundle elpa:auto-save-buffers-enhanced)
(el-get-bundle hiwin)
(el-get-bundle maxframe)
(el-get-bundle python-mode)
(el-get-bundle py-autopep8)
(el-get-bundle elpa:markdown-mode)
(el-get-bundle jedi)

;;====================================================================
;; reload .emacs
;;====================================================================
(defun reload-dotemacs()
  "Reload the .emacs file"
  (interactive)
  (load-file (locate-user-emacs-file "init.el"))
  )

(global-set-key "\C-x," 'reload-dotemacs)

;;====================================================================
;; init-load 
;;====================================================================
(init-loader-load (locate-user-emacs-file "conf"))
