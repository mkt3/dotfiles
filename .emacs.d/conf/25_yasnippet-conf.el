(use-package yasnippet
  :straight yasnippet
  :straight yasnippet-snippets
  :config
  (setq yas-snippet-dirs
        '("~/.dotfiles/.emacs.d/snippets"    ;; 自作スニペット
          yas-installed-snippets-dir         ;; package に最初から含まれるスニペット
          ))
  
  ;; yas起動
  (yas-global-mode 1)
  )

