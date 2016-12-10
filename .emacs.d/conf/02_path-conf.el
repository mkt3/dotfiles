(let ((path-str
           (replace-regexp-in-string
                       "\n+$" "" (shell-command-to-string "echo $PATH"))))
     (setenv "PATH" path-str)
          (setq exec-path (nconc (split-string path-str ":") exec-path)))
