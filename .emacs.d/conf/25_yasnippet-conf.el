(use-package yasnippet
  :straight yasnippet
  :straight yasnippet-snippets
  :config
  (setq yas-snippet-dirs
        '("~/.dotfiles/.emacs.d/snippets"    ;; 自作スニペット
          "~/.dotfiles/.emacs.d/straight/build/yasnippet-snippets/snippets"         ;; package に含まれるスニペット
          ))

  ;; yas起動
  (yas-global-mode 1)
  )
