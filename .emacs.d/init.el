(prog1 "prepare leaf"
  (prog1 "package"
    (custom-set-variables
     '(package-archives '(("org"   . "https://orgmode.org/elpa/")
                          ("melpa" . "https://melpa.org/packages/")
                          ("gnu"   . "https://elpa.gnu.org/packages/"))))
    (package-initialize))

  (prog1 "leaf"
    (unless (package-installed-p 'leaf)
      (unless (assoc 'leaf package-archive-contents)
        (package-refresh-contents))
      (condition-case err
          (package-install 'leaf)
        (error
         (package-refresh-contents)       ; renew local melpa cache if fail
         (package-install 'leaf))))

    (leaf leaf-keywords
      :ensure t
      :init
      (leaf diminish
        :ensure t)

      :config (leaf-keywords-init)))

  (prog1 "optional packages for leaf-keywords"
    ;; optional packages if you want to use :hydra, :el-get,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t
      :custom ((el-get-git-shallow-clone  . t)))))


(leaf *initialize-emacs
  :config
  (leaf exec-path-from-shell
    :ensure t
    :when (memq window-system '(mac ns x))
    :defun (exec-path-from-shell-initialize)
    :custom ((exec-path-from-shell-check-startup-files . nil)
             (exec-path-from-shell-variables . '("PATH" "GOPATH")))
    :config
    (exec-path-from-shell-initialize))

  (leaf cus-edit
    :custom `((custom-file . ,(locate-user-emacs-file "custom.el")))))

(leaf *emacs-buildin
  :config
  (leaf cus-start
    :doc "define customization properties of builtins"
    :custom `((garbage-collection-messages     . t)
              (fill-column                     . 65)
              (tab-width                       . 4)
              (create-lockfiles                . nil)
              (make-backup-files               . nil);; backup fileの作成を停止
              (auto-save-default               . nil) ;; auto-save fileの作成を停止
              (use-dialog-box                  . nil)
              (column-number-mode              . t)
              (use-file-dialog                 . nil)
              (frame-resize-pixelwise          . t)
              (enable-recursive-minibuffers    . t)
              (history-length                  . 1000)
              (history-delete-duplicates       . t)
              (scroll-preserve-screen-position . t)
              (scroll-margin                   . 5)
              (scroll-conservatively           . 1)
              (next-screen-context-lines       . 5)
              (mouse-wheel-scroll-amount       . '(1 ((control) . 5)))
              (ring-bell-function              . 'ignore)
              (text-quoting-style              . 'straight)
              (truncate-lines   . nil)
              (truncate-partial-width-windows . nil)
              (menu-bar-mode    . nil)
              (tool-bar-mode    . nil)
              (scroll-bar-mode  . nil)
              (fringe-mode      . 10)
              (indent-tabs-mode . nil)
              (inhibit-startup-message . t)
              (inhibit-startup-screen . t)
              (gc-cons-threshold . ,(* gc-cons-threshold 10)))
    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    (keyboard-translate ?\C-h ?\C-?)
    )

  (leaf *default-keybind
    :bind (("M-+" . text-scale-increase)
           ("M-=" . text-scale-increase)
           ("M--" . text-scale-decrease)
           ("C-c l" . toggle-truncate-lines)
           ("C-x |" . split-window-right)
           ("C-x -" . split-window-below)
           ("C-x x" . delete-window)))

  (leaf *lisp
    :config
    (leaf simple
      :custom ((kill-ring-max . 100)
               (kill-read-only-ok . t)
               (kill-whole-line . t)
               (eval-expression-print-length . nil)
               (eval-expression-print-lepvel  . nil))
      ;; :hook ((before-save-hook . delete-trailing-whitespace))
      )

    (leaf abbrev
      :diminish abbrev-mode)

    (leaf display-line-numbers
      :config
      (global-display-line-numbers-mode) ;; 行番号を常に表示
      )

    (leaf delsel
      :custom ((delete-selection-mode . t)))

    (leaf uniquify
      :custom ((uniquify-buffer-name-style . 'post-forward-angle-brackets)
            (uniquify-min-dir-content . 1)
            (funiquify-ignore-buffers-re . "*[^*]+*")))

    (leaf elec-pair
      :custom ((electric-pair-mode . t)))

    (leaf time
      :custom ((display-time-string-forms . '(month "/" day "(" dayname ") " 24-hours ":" minutes))
               (display-time-mode . t)))

    (leaf autorevert
      :doc "revert buffers when files on disk change"
      :custom ((auto-revert-interval . 0.1)
               (global-auto-revert-mode . t)))

    (leaf autoinsert
      :doc "automatic mode-dependent insertion of text into new files"
      :custom ((auto-insert-mode . t)))

    (leaf paren
      :custom ((show-paren-delay . 0.0)
               (show-paren-mode  . t)))

    (leaf save-place-mode
      :doc "automatically save place in files"
      :custom ((save-place-mode . t)))

    (leaf windmove
      :custom (windmove-wrap-around . t)
      :bind (("C-M-h" . windmove-left)
             ("C-M-k" . windmove-up)
             ("C-M-j" . windmove-down)
             ("C-M-l" . windmove-right)))
    )
  (leaf *lisp/vc
    :config
    (leaf vc-hooks
      :custom ((vc-follow-symlinks . t))))
  )
(leaf *color-theme
  :config
  (leaf doom-themes
    :ensure t
    :require t
    :custom ((doom-themes-enable-italic . t)
             (doom-themes-enable-bold . t))
    :custom-face ((doom-modeline-bar . '((t (:background "#6272a4")))))
    :config
    (load-theme 'doom-dracula t)
    (doom-themes-neotree-config)
    (doom-themes-org-config)

    (leaf doom-modeline
      :ensure t
      :custom ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
               (doom-modeline-icon . t)
               (doom-modeline-major-mode-icon . nil)
               (doom-modeline-minor-modes . nil))
      :hook
      ((after-init-hook . doom-modeline-mode))
      :config
      (set-cursor-color "cyan")
      ))
  )

(leaf *ui
  :config
  (leaf mac
    :doc "implementation of gui terminal on macos"
    :doc "each symbol can be `control', `meta', `alt', `hyper', or `super'"
    :doc "`left' meens same value setting its left key"
    :when (eq 'mac window-system)
    :custom ((mac-control-modifier       . 'control)
             (mac-option-modifier        . 'super)
             (mac-command-modifier       . 'meta)

             (mac-right-control-modifier . 'control)
             (mac-right-option-modifier  . 'hyper)
             (mac-right-command-modifier . 'meta)

             ;; use fn key as normal way.
             ;; (mac-function-modifier      . 'super)
             ))

  (leaf ns
    :doc "next/open/gnustep / macos communication module"
    :when (eq 'ns window-system)
    :custom ((ns-control-modifier       . 'control)
         (ns-option-modifier        . 'super)
         (ns-command-modifier       . 'meta)

         (ns-right-control-modifier . 'control)
         (ns-right-option-modifier  . 'hyper)
         (ns-right-command-modifier . 'meta)
         ;; use fn key as normal way.
         (ns-function-modifier      . 'super))
    :config
    (setq default-frame-alist (append '((inhibit-double-buffering . t)
                                        (ns-appearance            . dark)
                                        (ns-transparent-titlebar  . t)
                                        ) default-frame-alist))
    )

  (leaf *font
    :when window-system
    :config
    (add-to-list 'default-frame-alist '(font . "Hackgen-16")))

  (leaf *frame
    :init
    (setq default-frame-alist (append '((line-spacing         . 0  ) ; 文字間隔
                                        (left-fringe          . 10 ) ; 左フリンジ幅
                                        (right-fringe         . 11 ) ; 右フリンジ幅
                                        (scroll-bar-width     . 17 ) ; スクロールバー幅
                                        (cursor-type          . box) ; カーソル種別
                                        (alpha                . 95 ) ; 透明度
                                        ) default-frame-alist))
    :custom
    (initial-frame-alist . default-frame-alist)
    (frame-title-format . '("emacs " emacs-version (buffer-file-name " - %f")))
    :bind(("C-c C-f" . toggle-frame-maximized)))
  )

(leaf *minor-mode
  :config
  (leaf dimmer
    :ensure t
    :custom ((dimmer-fraction . 0.5)
             (dimmer-exclusion-regexp-list . '(".*Minibuf.*"
                                               ".*which-key.*"
                                               ".*NeoTree.*"
                                               ".*Messages.*"
                                               ".*Async.*"
                                               ".*Warnings.*"
                                               ".*LV.*"
                                               ".*Ilist.*"))
             (dimmer-mode . t)))

  (leaf which-key
    :ensure t
    :custom ((which-key-idle-delay . 1)
             (which-key-replacement-alist
              . '(((nil . "Prefix Command") . (nil . "prefix"))
                  ((nil . "\\`\\?\\?\\'") . (nil . "lambda"))
                  (("<left>") . ("←"))
                  (("<right>") . ("→"))
                  (("<\\([[:alnum:]-]+\\)>") . ("\\1"))))
             (which-key-mode . t)))

  (leaf ace-window
    :ensure t
    :bind (("C-x o" . ace-window))
    :custom ((aw-keys . '(?j ?k ?l ?i ?o ?h ?y ?u ?p)))
    :custom-face ((aw-leading-char-face . '((t (:height 4.0 :foreground "#f1fa8c"))))))

  (leaf popwin
    :ensure t)

  (leaf amx
    :ensure t)

  (leaf undo-tree
    :ensure t
    :leaf-defer nil
    :custom ((global-undo-tree-mode . t))
    :bind (  ("M-/" . undo-tree-redo)))

  (leaf undohist
    :ensure t
    :commands (undohist-initialize)
    :config (undohist-initialize))

  (leaf whitespace
    :ensure t
    :commands whitespace-mode
    :bind ("C-c W" . whitespace-cleanup)
    :custom ((whitespace-style . '(face           ; faceで可視化
                                  trailing       ; 行末
                                  tabs           ; タブ
                                  spaces         ; スペース
                                  empty          ; 先頭/末尾の空行
                                  space-mark     ; 表示のマッピング
                                  tab-mark))
             (whitespace-display-mappings . '((space-mark ?\u3000 [?\u25a1])
                                              ;; WARNING: the mapping below has a problem.
                                              ;; When a TAB occupies exactly one column, it will display the
                                              ;; character ?\xBB at that column followed by a TAB which goes to
                                              ;; the next TAB column.
                                              ;; If this is a problem for you, please, comment the line below.
                                              (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
             (whitespace-space-regexp . "\\(\u3000+\\)")
             (whitespace-global-modes . '(emacs-lisp-mode shell-script-mode sh-mode python-mode org-mode))
             (global-whitespace-mode . t))

    :config
    (defvar my/bg-color "#232323")
    (set-face-attribute 'whitespace-trailing nil
                        :background my/bg-color
                        :foreground "DeepPink"
                        :underline t)
    (set-face-attribute 'whitespace-tab nil
                        :background my/bg-color
                        :foreground "LightSkyBlue"
                        :underline t)
    (set-face-attribute 'whitespace-space nil
                        :background my/bg-color
                        :foreground "GreenYellow"
                        :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                        :background my/bg-color)
    )
  (leaf mwim
    :ensure t
    :bind (("C-a" . mwim-beginning-of-code-or-line)
           ("C-e" . mwim-end-of-code-or-line)))

  (leaf skk
    :ensure ddskk
    :defun (skk-get)
    :require t skk-study
    :bind (("C-x j"  . skk-mode))
    :custom ((default-input-method . "japanese-skk"))
    :init
    (setq skk-user-directory "~/.emacs.d/ddskk.d")
    (setq viper-mode nil)
    (add-hook 'lisp-interaction-mode-hook
              '(lambda()
                 (progn
                   (eval-expression (skk-mode) nil)
                   (skk-latin-mode (point))
                   )))
    )

  (leaf ivy
    :ensure t
    :leaf-defer nil
    :custom ((ivy-mode . t)
             (counsel-mode . t)
             )
    :bind ((:ivy-minibuffer-map
            ("C-w" . ivy-backward-kill-word)
            ("C-k" . ivy-kill-line)
            ("RET" . ivy-alt-done)
            ("C-h" . ivy-backward-delete-char)))
    :init
    (leaf *ivy-requirements
      :config
      (leaf swiper
        :ensure t
        :bind (([remap isearch-forward] . swiper)))
      (leaf counsel
        :ensure t
        :bind (("M-s c" . counsel-ag)
               ("M-o f" . counsel-fzf)
               ("M-o r" . counsel-recentf)
               ("M-y" . counsel-yank-pop)
               ;; ([remap isearch-forward] . counsel-imenu)
               ("C-x C-r" . counsel-recentf))
        :custom `((counsel-find-file-ignore-regexp
                  p . ,(rx-to-string '(| "./" "../") 'no-group))))
      :custom ((ivy-initial-inputs-alist   . nil)
               (counsel-yank-pop-separator . "\n----------\n")))
    :config
    (leaf *other-ivy-packages
      :config
      (leaf ivy-prescient
        :when (version<= "25.1" emacs-version)
        :init
        (leaf prescient
          :custom `((prescient-aggressive-file-save . t)
                    (prescient-save-file            . ,(locate-user-emacs-file "prescient"))
                    (prescient-persist-mode         . t)))
        :ensure t
        :custom ((ivy-prescient-retain-classic-highlighting . t)
                 (ivy-prescient-mode . t)))

      (leaf ivy-hydra
        :doc "Additional key bindings for Ivy"
        :ensure t
        :bind (("C-c i i" . hydra-ivy/body)))

      (leaf ivy-xref
        :doc "Ivy interface for xref results"
        :when (version<= "25.1" emacs-version)
        :ensure t
        :custom ((xref-show-xrefs-function . #'ivy-xref-show-xrefs)))

      (leaf ivy-rich
        :doc "More friendly display transformer for ivy"
        :ensure t
        :custom ((ivy-rich-mode . t)))

      ;; (leaf ivy-point-history
      ;;   :el-get SuzumiyaAoba/ivy-point-history
      ;;   :bind (("C-c b p" . ivy-point-history))
      ;;   :require t)

      (leaf all-the-icons-ivy
        :when window-system
        :after all-the-icons
        :defun (all-the-icons-ivy-setup)
        :ensure t
        :config (all-the-icons-ivy-setup))

      (leaf flx :ensure t)
      ;; Enhance M-x
      (leaf amx :ensure t)

      (leaf ivy-yasnippet
        :ensure t
        :bind ("C-c y s" . ivy-yasnippet)
        :config
        (setq ivy-yasnippet-expand-keys "smart") ; nil "always" , "smart"
                                        ; https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-ivy.el
        (advice-add #'ivy-yasnippet--preview :override #'ignore))
      )

    (leaf *ivy-integration
      :config
      ;; Integration with `projectile'
      (leaf counsel-projectile
        :ensure t
        :after projectile
        :custom ((projectile-completion-system . 'ivy)
                 (counsel-projectile-mode . t)))
      ;; Integration with `magit'
      (leaf *magit-integration
        :after magit
        :custom (((magit-completing-read-function . 'ivy-completing-read))))))

  (leaf company
    :ensure t
    :leaf-defer nil
    :diminish company-mode
    :bind ((company-active-map
            ("M-n" . nil)
            ("M-p" . nil)
            ("C-s" . company-filter-candidates)
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)
            ("C-i" . company-complete-selection))
           (company-search-map
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)))
    :custom ((company-tooltip-limit         . 12)
             (company-idle-delay            . 0)
             (company-minimum-prefix-length . 1)
             (company-transformers          . '(company-sort-by-occurrence))
             (global-company-mode           . t)
             (company-selection-wrap-around . t))
    :config
    (leaf company-prescient
      :ensure t
      :custom ((company-prescient-mode . t)))
    (leaf company-box
      :url "https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-company.el"
      :when (version<= "26.1" emacs-version)
      :disabled (eq window-system 'x)
      :ensure t
      :diminish company-box-mode
      :defvar (company-box-icons-alist company-box-icons-all-the-icons)
      :init (leaf all-the-icons :ensure t :require t)
      :custom ((company-box-max-candidates . 50)
               (company-box-icons-alist    . 'company-box-icons-all-the-icons))
      :hook ((company-mode-hook . company-box-mode))
      :config
      (when (memq window-system '(ns mac))
        (declare-function all-the-icons-faicon 'all-the-icons)
        (declare-function all-the-icons-material 'all-the-icons)
        (declare-function all-the-icons-octicon 'all-the-icons)
        (setq company-box-icons-all-the-icons
              `((Unknown       . ,(all-the-icons-material "find_in_page" :height 0.9 :v-adjust -0.2))
                (Text          . ,(all-the-icons-faicon "text-width" :height 0.85 :v-adjust -0.05))
                (Method        . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.05 :face 'all-the-icons-purple))
                (Function      . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.05 :face 'all-the-icons-purple))
                (Constructor   . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.05 :face 'all-the-icons-purple))
                (Field         . ,(all-the-icons-octicon "tag" :height 0.85 :v-adjust 0 :face 'all-the-icons-lblue))
                (Variable      . ,(all-the-icons-octicon "tag" :height 0.85 :v-adjust 0 :face 'all-the-icons-lblue))
                (Class         . ,(all-the-icons-material "settings_input_component" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-orange))
                (Interface     . ,(all-the-icons-material "share" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-lblue))
                (Module        . ,(all-the-icons-material "view_module" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-lblue))
                (Property      . ,(all-the-icons-faicon "wrench" :height 0.85 :v-adjust -0.05))
                (Unit          . ,(all-the-icons-material "settings_system_daydream" :height 0.9 :v-adjust -0.2))
                (Value         . ,(all-the-icons-material "format_align_right" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-lblue))
                (Enum          . ,(all-the-icons-material "storage" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-orange))
                (Keyword       . ,(all-the-icons-material "filter_center_focus" :height 0.9 :v-adjust -0.2))
                (Snippet       . ,(all-the-icons-material "format_align_center" :height 0.9 :v-adjust -0.2))
                (Color         . ,(all-the-icons-material "palette" :height 0.9 :v-adjust -0.2))
                (File          . ,(all-the-icons-faicon "file-o" :height 0.9 :v-adjust -0.05))
                (Reference     . ,(all-the-icons-material "collections_bookmark" :height 0.9 :v-adjust -0.2))
                (Folder        . ,(all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05))
                (EnumMember    . ,(all-the-icons-material "format_align_right" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-lblue))
                (Constant      . ,(all-the-icons-faicon "square-o" :height 0.9 :v-adjust -0.05))
                (Struct        . ,(all-the-icons-material "settings_input_component" :height 0.9 :v-adjust -0.2 :face 'all-the-icons-orange))
                (Event         . ,(all-the-icons-faicon "bolt" :height 0.85 :v-adjust -0.05 :face 'all-the-icons-orange))
                (Operator      . ,(all-the-icons-material "control_point" :height 0.9 :v-adjust -0.2))
                (TypeParameter . ,(all-the-icons-faicon "arrows" :height 0.85 :v-adjust -0.05))
                (Template      . ,(all-the-icons-material "format_align_center" :height 0.9 :v-adjust -0.2))))
        (setq company-box-icons-alist 'company-box-icons-all-the-icons)))

    (leaf company-quickhelp
      :when (display-graphic-p)
      :ensure t
      :custom ((company-quickhelp-delay . 0.8)
               (company-quickhelp-mode  . t))
      :bind (company-active-map
             ("M-h" . company-quickhelp-manual-begin))
      :hook ((company-mode-hook . company-quickhelp-mode)))

    (leaf company-math
      :ensure t
      :defvar (company-backends)
      :preface
      (defun c/latex-mode-setup ()
        (setq-local company-backends
                    (append '((company-math-symbols-latex
                               company-math-symbols-unicode
                               company-latex-commands))
                            company-backends)))
      :hook ((org-mode-hook . c/latex-mode-setup)
             (tex-mode-hook . c/latex-mode-setup)))
    (leaf yasnippet
      :ensure t
      :url "https://kiwanami.hatenadiary.org/entry/20110224/1298526678"
      :diminish yas-minor-mode
      :custom ((yas-indent-line . 'fixed)
               (yas-global-mode . t)
               (yas-snippet-dirs . '("~/.dotfiles/.emacs.d/snippets"    ;; 自作スニペット
                                     "~/.dotfiles/.emacs.d/straight/build/yasnippet-snippets/snippets"         ;; package に含まれるスニペット
                                     )))
      :bind ((yas-keymap
              ("<tab>" . nil))            ; conflict with company
             (yas-minor-mode-map
              ("C-c y i" . yas-insert-snippet)
              ("C-c y n" . yas-new-snippet)
              ("C-c y v" . yas-visit-snippet-file)
              ("C-c y l" . yas-describe-tables)
              ("C-c y g" . yas-reload-all)))
      :config
      (leaf yasnippet-snippets :ensure t)
      (leaf yatemplate
        :ensure t
        :config
        (yatemplate-fill-alist))
      (defvar company-mode/enable-yas t
        "Enable yasnippet for all backends.")
      (defun company-mode/backend-with-yas (backend)
        (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
            backend
          (append (if (consp backend) backend (list backend))
                  '(:with company-yasnippet))))
      (defun set-yas-as-company-backend ()
        (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
        )
      :hook
      ((company-mode-hook . set-yas-as-company-backend))
      ))

  (leaf posframe
    :ensure t
    :when (version<= "26.1" emacs-version)
    :when window-system
    :preface
    (defun posframe-poshandler-frame-bottom-center (info)
      "Posframe's position handler.
Get a position which let posframe stay onto its parent-frame's
bottom center.  The structure of INFO can be found in docstring of
`posframe-show'."
      (cons (/ (- (plist-get info :parent-frame-width)
                  (plist-get info :posframe-width))
               2)
            (- 0
               (plist-get info :mode-line-height)
               (plist-get info :minibuffer-height))))

    (defun posframe-poshandler-window-top-center (info)
      "Posframe's position handler.
Get a position which let posframe stay onto current window's
top center.  The structure of INFO can be found in docstring of
`posframe-show'."
      (let* ((window-left (plist-get info :parent-window-left))
             (window-top (plist-get info :parent-window-top))
             (window-width (plist-get info :parent-window-width))
             (posframe-width (plist-get info :posframe-width)))
        (cons (+ window-left (/ (- window-width posframe-width) 2))
              window-top)))

    (defun posframe-poshandler-window-bottom-center (info)
      "Posframe's position handler.
Get a position which let posframe stay onto current window's
bottom center.  The structure of INFO can be found in docstring of
`posframe-show'."
      (let* ((window-left (plist-get info :parent-window-left))
             (window-top (plist-get info :parent-window-top))
             (window-width (plist-get info :parent-window-width))
             (window-height (plist-get info :parent-window-height))
             (posframe-width (plist-get info :posframe-width))
             (posframe-height (plist-get info :posframe-height))
             (mode-line-height (plist-get info :mode-line-height)))
        (cons (+ window-left (/ (- window-width posframe-width) 2))
              (+ window-top window-height
                 (- 0 mode-line-height posframe-height)))))
    :config
    (leaf ivy-posframe
      :doc "Using posframe to show Ivy"
      :after ivy
      :ensure t
      :diminish ivy-posframe-mode
      :defun (ivy-posframe--display posframe-poshandler-frame-bottom-center)
      :preface
      (defun ivy-posframe-display-at-frame-bottom-center (str)
        (ivy-posframe--display str #'posframe-poshandler-frame-bottom-center))
      :custom ((ivy-posframe-mode . t)
               (ivy-posframe-height-alist . '((swiper . 30) (t . 40)))
               (ivy-posframe-display-functions-alist
                . '((swiper . nil) (t . ivy-posframe-display-at-frame-bottom-center)))
               (ivy-posframe-parameters . '((left-fringe . 10)))))

    (leaf company-posframe
      :doc "Use a posframe as company candidate menu"
      :ensure t
      ;; Currently, posframe has a issue for changing child-frame with GNOME
      ;; Ref: https://github.com/tumashu/company-posframe/issues/2
      :disabled (eq window-system 'x)
      :after company
      :diminish company-posframe-mode
      :custom ((company-posframe-mode . t)))

    (leaf flycheck-posframe
      :ensure t
      :after flycheck
      :custom ((flycheck-posframe-mode . t)))

    (leaf which-key-posframe
      :ensure t
      :after which-key
      :custom ((which-key-posframe-mode . t)))

    (leaf ddskk-posframe
      :doc "Show Henkan tooltip for ddskk via posframe"
      ;; Currently, posframe has a issue for changing child-frame with GNOME
      ;; Ref: https://github.com/tumashu/company-posframe/issues/2
      :disabled (eq window-system 'x)
      :ensure t
      :after skk
      :custom ((ddskk-posframe-mode . t))))

  (leaf highlight-indent-guides
    :ensure t
    :require t
    :diminish
    :hook (((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))
    :custom (
             (highlight-indent-guides-method . 'character)  ;; fill,column,character
             (highlight-indent-guides-auto-enabled . t)  ;; automatically calculate faces.
             (highlight-indent-guides-responsive . t)
             (highlight-indent-guides-character . ?\|)))
    ;; :config
    ;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))
  (leaf imenu-list
    :ensure t
    :bind (("C-o" . imenu-list-smart-toggle))
    :custom-face
    (imenu-list-entry-face-1 . '((t (:foreground "white"))))
    :custom ((imenu-list-focus-after-activation . t)
             (imenu-list-auto-resize . t))
    )

  (leaf projectile
    :when (version<= "25.1" emacs-version)
    :ensure t
    :leaf-defer nil
    :bind (("M-o p" . projectile-command-map))
    :custom ((projectile-mode . t)))

  (leaf persp-mode
    :ensure t
    :leaf-defer nil
    :custom `((persp-keymap-prefix                 . ,(kbd "C-c p"))
              (persp-nil-name                      . "default")
              (persp-set-last-persp-for-new-frames . nil)
              (persp-init-frame-behaviour          . nil)
              (persp-auto-resume-time              . 0.1)
              (persp-mode . t))
    :hook ((emacs-startup-hook . toggle-frame-maximized))
    :config
    ;; NOTE: Redefine `persp-add-new' to raddress.
    ;; Issue: Unable to create/handle persp-mode
    ;; https://github.com/Bad-ptr/persp-mode.el/issues/96
    ;; https://github.com/Bad-ptr/persp-mode-projectile-bridge.el/issues/4
    ;; https://emacs-china.org/t/topic/6416/7
    ;; (defun* persp-add-new (name &optional (phash *persp-hash*))
    ;;   "Create a new perspective with the given `NAME'. Add it to `PHASH'.
    ;; Return the created perspective."
    ;;   (interactive "sA name for the new perspective: ")
    ;;   (if (and name (not (equal "" name)))
    ;;       (destructuring-bind (e . p)
    ;;           (persp-by-name-and-exists name phash)
    ;;         (if e p
    ;;           (setq p (if (equal persp-nil-name name)
    ;;                  nil (make-persp :name name)))
    ;;           (persp-add p phash)
    ;;           (run-hook-with-args 'persp-created-functions p phash)
    ;;           p))
    ;;     (message "[persp-mode] Error: Can't create a perspective with empty name.")
    ;;     nil))

    ;; Ignore temporary buffers
    ;; (add-hook 'persp-common-buffer-filter-functions
    ;;           (lambda (b) (or (string-prefix-p "*" (buffer-name b))
    ;;                 (string-prefix-p "magit" (buffer-name b)))))
    )
  (leaf rainbow-delimiters
    :ensure t
    :hook
    ((prog-mode-hook       . rainbow-delimiters-mode)))
  ;; (leaf hide-mode-line
  ;;   :hook
  ;;   ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode))

  (leaf nyan-mode
    :ensure t
    :require t
    :custom ((nyan-cat-face-number . 4)
             (nyan-animate-nyancat . t))
    :hook
    ((doom-modeline-mode-hook . nyan-mode)))
  )

(leaf *major-mode
  :config
  (leaf *python
    :config
    (leaf elpy
      :ensure t
      :init
      (elpy-enable)
      :config
      (remove-hook 'elpy-modules 'elpy-module-highlight-indentation)
      :custom ((elpy-rpc-virtualenv-path . 'current))
      )

    (leaf py-isort
      :ensure t
      :after python-mode
      :hook ((before-save-hook . py-isort-before-save)))

    ;; (leaf auto-virtualenvwrapper
    ;;   :ensure t
    ;;   :require t
    ;;   :config
    ;;   (defun wrapper-auto-virtualenvwrapper-activate ()
    ;;     (let ((path (auto-virtualenvwrapper-find-virtualenv-path)))
    ;;       (when (and path (not (equal path auto-virtualenvwrapper--path)))
    ;;         (setq auto-virtualenvwrapper--path path
    ;;               venv-current-name (file-name-base (file-truename path)))
    ;;         (venv--activate-dir auto-virtualenvwrapper--path)
    ;;         (pyvenv-activate auto-virtualenvwrapper--path)
    ;;         (auto-virtualenvwrapper-message "activated virtualenv: %s" auto-virtualenvwrapper--path))))
    ;;   ;; :hook ((python-mode-hook forcus-in-hook . wrapper-auto-virtualenvwrapper-activate))
    ;;   ;; :init
    ;;   (add-hook 'python-mode-hook #'wrapper-auto-virtualenvwrapper-activate)
    ;;   (add-hook 'focus-in-hook #'wrapper-auto-virtualenvwrapper-activate)
    ;;   )
    ;; )
    )
  (leaf yaml-mode :ensure t)

  (leaf web-mode
    :ensure t
    :mode ("\\.css\\'"
           "\\.js\\'" "\\.json\\'" "\\.p?html?\\'"
           "\\.php\\'" "\\.tsx\\'" "\\.vue\\'" "\\.xml\\'"))
  )

  (leaf *docker-modes
    :config
    (leaf docker              :ensure t)
    (leaf dockerfile-mode     :ensure t)
    (leaf docker-compose-mode :ensure t)
    (leaf docker-tramp        :ensure t))

(leaf *misc-tools
  :config
  (leaf *git-tools
    :config
    (leaf gitattributes-mode :ensure t)
    (leaf gitconfig-mode     :ensure t)
    (leaf gitignore-mode     :ensure t)

    (leaf magit
      :when (version<= "25.1" emacs-version)
      :ensure t
      :preface
      (defun c/git-add ()
        "Add anything."
        (interactive)
        (shell-command "git add ."))
      (defun c/git-commit-a ()
        "Commit after add anything."
        (interactive)
        (c/git-add)
        (magit-commit-create))
      :bind (("C-x g" . magit-status)
             ("C-x M-g" . magit-dispatch-popup))
      ))

  (leaf shell-pop
    :ensure t
    :bind* (("C-t" . shell-pop))
    :config
    (custom-set-variables
     '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
     '(shell-pop-window-size 30)
     '(shell-pop-full-span t)
     '(shell-pop-window-position "bottom"))
    ;; 終了時のプロセス確認を無効化
    (defun set-no-process-query-on-exit ()
      (let ((proc (get-buffer-process (current-buffer))))
        (when (processp proc)
          (set-process-query-on-exit-flag proc nil))))
    (add-hook 'term-exec-hook 'set-no-process-query-on-exit)
    )

  ;; (leaf multi-term
  ;;   :ensure t
  ;;   :custom `((multi-term-program . ,(getenv "SHELL")))
  ;;   :preface
  ;;   (defun namn/open-shell-sub (new)
  ;;     (split-window-below)
  ;;     (enlarge-window 5)
  ;;     (other-window 1)
  ;;     (let ((term) (res))
  ;;       (if (or new (null (setq term (dolist (buf (buffer-list) res)
  ;;                                      (if (string-match "*terminal<[0-9]+>*" (buffer-name buf))
  ;;                                          (setq res buf))))))
  ;;           (multi-term)
  ;;         (switch-to-buffer term))))
  ;;   (defun namn/open-shell ()
  ;;     (interactive)
  ;;     (namn/open-shell-sub t))
  ;;   (defun namn/to-shell ()
  ;;     (interactive)
  ;;     (namn/open-shell-sub nil))
  ;;   :bind (("C-^"   . namn/to-shell)
  ;;          ("C-M-^" . namn/open-shell)
  ;;          (:term-raw-map
  ;;           ("C-t" . other-window))))
  )
