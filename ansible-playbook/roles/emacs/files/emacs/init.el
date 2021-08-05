;; common lisp
(eval-when-compile (require 'cl-lib nil t))
(setq byte-compile-warnings '(not cl-functions obsolete))

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
  :ensure t
  :bind (("M-=" . transient-dwim-dispatch)))

(leaf *initialize-emacs
  :config
  (leaf exec-path-from-shell
    :ensure t
    :when (memq window-system '(mac ns x))
    :defun (exec-path-from-shell-initialize)
    :custom ((exec-path-from-shell-arguments . "") ; zshの.zshrcでinteractiveのUIにしているため
             (exec-path-from-shell-variables . '("PATH" "GOPATH")))
    :config
    (exec-path-from-shell-initialize))

  (leaf cus-edit
    :custom `((custom-file . ,(locate-user-emacs-file "custom.el")))))

(leaf *emacs-buildin
  :config
  (leaf cus-start
    :doc "define customization properties of builtins"
    :doc "define customization prop"
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
              (truncate-lines                  . nil)
              (truncate-partial-width-windows  . nil)
              (menu-bar-mode                   . nil)
              (tool-bar-mode                   . nil)
              (scroll-bar-mode                 . nil)
              (fringe-mode                     . 10)
              (indent-tabs-mode                . nil)
              (inhibit-startup-message         . t)
              (inhibit-startup-screen          . t)
              (gc-cons-threshold               . ,(* gc-cons-threshold 100)))
    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    (keyboard-translate ?\C-h ?\C-?)
    )

  (leaf *default-keybind
    :bind (("M-+"   . text-scale-increase)
           ("M--"   . text-scale-decrease)
           ("C-c l" . toggle-truncate-lines)
           ("C-x |" . split-window-right)
           ("C-x -" . split-window-below)
           ("C-x x" . delete-window)))

  (leaf *lisp
    :config
    (leaf simple
      :custom ((kill-ring-max     . 100)
               (kill-read-only-ok . t)
               (kill-whole-line   . t)
               (eval-expression-print-length . nil)
               (eval-expression-print-lepvel  . nil))
      )

    (leaf abbrev
      :blackout (abbrev-mode . " Abv"))

    (leaf files
      :setq-default ((find-file-visit-truename . t)))

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
      :tag "builtin"
      :custom ((auto-revert-interval . 0.1))
      :global-minor-mode global-auto-revert-mode)

    (leaf autoinsert
      :doc "automatic mode-dependent insertion of text into new files"
      :custom ((auto-insert-mode . t)))

    (leaf paren
      :custom-face (show-paren-match . '((t (:weight regular :background "#44475a" :underline "$ffff00"))))
      :custom ((show-paren-delay . 0.0)
               (show-paren-mode  . t))
      )

    (leaf save-place-mode
      :doc "automatically save place in files"
      :custom ((save-place-mode . t)))

    (leaf windmove
      :custom (windmove-wrap-around . t)
      :bind (("C-M-h" . windmove-left)
             ("C-M-k" . windmove-up)
             ("C-M-j" . windmove-down)
             ("C-M-l" . windmove-right)))

    (leaf gcmh
      :ensure t
      :custom
      (gcmh-verbose . t)
      :config
      (gcmh-mode 1))
    )
  (leaf *lisp/vc
    :config
    (leaf vc-hooks
      :custom ((vc-follow-symlinks . t))))
  )

(leaf *color-theme
  :config
  ;; (leaf modus-themes
  ;;   :ensure t
  ;;   :require t
  ;;   :custom
  ;;   ((modus-themes-italic-constructs . t)
  ;;    (modus-themes-bold-constructs . t)
  ;;    (modus-themes-region . '(bg-only no-extend))
  ;;    (modus-themes-syntax . 'faint)
  ;;    (modus-themes-diffs . 'deuteranopia)
  ;;    )
  ;;   :config
  ;;   (modus-themes-load-themes)
  ;;   (modus-themes-load-vivendi))

  (leaf doom-themes
    :ensure t
    :require t
    :custom ((doom-themes-enable-italic . t)
             (doom-themes-enable-bold   . t))
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

  (leaf *language
    :config
    (set-language-environment 'Japanese)
    (prefer-coding-system 'utf-8))

  (leaf *font
    :when window-system
    :config
    (add-to-list 'default-frame-alist '(font . "Cica-18")))

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
  (leaf tab-bar-mode
    :init
    (defvar my:ctrl-o-map (make-sparse-keymap)
      "My original keymap binded to C-o.")
    (defalias 'my:ctrl-o-prefix my:ctrl-o-map)
    (define-key global-map (kbd "C-o") 'my:ctrl-o-prefix)
    (define-key my:ctrl-o-map (kbd "c")   'tab-new)
    (define-key my:ctrl-o-map (kbd "C-c") 'tab-new)
    (define-key my:ctrl-o-map (kbd "k")   'tab-close)
    (define-key my:ctrl-o-map (kbd "C-k") 'tab-close)
    (define-key my:ctrl-o-map (kbd "n")   'tab-next)
    (define-key my:ctrl-o-map (kbd "C-n") 'tab-next)
    (define-key my:ctrl-o-map (kbd "p")   'tab-previous)
    (define-key my:ctrl-o-map (kbd "C-p") 'tab-previous)
  ;;
    (defun my:tab-bar-tab-name-truncated ()
      "Custom: Generate tab name from the buffer of the selected window."
      (let ((tab-name (buffer-name (window-buffer (minibuffer-selected-window))))
            (ellipsis (cond
                       (tab-bar-tab-name-ellipsis)
                       ((char-displayable-p ?…) "…")
                     ("..."))))
        (if (< (length tab-name) tab-bar-tab-name-truncated-max)
            (format "%-12s" tab-name)
          (propertize (truncate-string-to-width
                       tab-name tab-bar-tab-name-truncated-max nil nil
                       ellipsis)
                      'help-echo tab-name))))
    :custom
    ((tab-bar-close-button-show      . nil)
     (tab-bar-close-last-tab-choice  . nil)
     (tab-bar-close-tab-select       . 'left)
     (tab-bar-history-mode           . nil)
     (tab-bar-new-tab-choice         . "*scratch*")
     (tab-bar-new-button-show        . nil)
     (tab-bar-tab-name-function      . 'my:tab-bar-tab-name-truncated)
     (tab-bar-tab-name-truncated-max . 12)
     (tab-bar-separator              . "")
     )
    :config
    (tab-bar-mode +1)
    )

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
    :global-minor-mode global-undo-tree-mode
    :bind (  ("M-/" . undo-tree-redo))
    :custom ((undo-tree-auto-save-history . t)
             (undo-tree-history-directory-alist . `(("." . ,(concat user-emacs-directory ".cache/undo-tree-hist/"))))))

  (leaf whitespace
    :ensure t
    :commands whitespace-mode
    :bind ("C-c W" . whitespace-cleanup)
    :custom ((whitespace-style . '(face
                                   trailing
                                   tabs
                                   spaces
                                   empty
                                   space-mark
                                   tab-mark))
             (whitespace-display-mappings . '((space-mark ?\u3000 [?\u25a1])
                                              (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
             (whitespace-space-regexp . "\\(\u3000+\\)")
             (whitespace-global-modes . '(emacs-lisp-mode shell-script-mode sh-mode python-mode org-mode markdown-mode rjsx-mode css-mode))
             (global-whitespace-mode . t))

    :config
    (set-face-attribute 'whitespace-trailing nil
                        :background "Black"
                        :foreground "DeepPink"
                        :underline t)
    (set-face-attribute 'whitespace-tab nil
                        :background "Black"
                        :foreground "LightSkyBlue"
                        :underline t)
    (set-face-attribute 'whitespace-space nil
                        :background "Black"
                        :foreground "GreenYellow"
                        :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                        :background "Black")
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
    :custom ((skk-server-portnum . 1178)
             (skk-server-host . "localhost")
             (default-input-method . "japanese-skk"))
    :init
    (setq skk-user-directory (concat user-emacs-directory "ddskk.d"))
    (setq viper-mode nil)
    :hook ((lisp-interaction-mode-hook . (lambda() (progn (eval-expression (skk-mode) nil) (skk-latin-mode (point)))))))

  (leaf vertico
    :ensure t
    :global-minor-mode t
    :preface
    (defun my:filename-upto-parent ()
      "Move to parent directory like \"cd ..\" in find-file."
      (interactive)
      (let ((sep (eval-when-compile (regexp-opt '("/" "\\")))))
        (save-excursion
          (left-char 1)
          (when (looking-at-p sep)
            (delete-char 1)))
        (save-match-data
          (when (search-backward-regexp sep nil t)
            (right-char 1)
            (filter-buffer-substring (point)
                                     (save-excursion (end-of-line) (point))
                                     #'delete)))))
    :custom ((vertico-count . 20)
             (enable-recursive-minibuffers .t)
             (vertico-cycle . t))
    :bind ((vertico-map
            ("C-r" . vertico-previous)
            ("C-s" . vertico-next)
            ("C-l" . my:filename-upto-parent)))
    :init
    (savehist-mode)
    )

  (leaf consult
    :ensure t
    :preface
    (defun my:consult-line (&optional at-point)
      (interactive "P")
      (if at-point
          (consult-line (thing-at-point 'symbol))
        (consult-line)))
    :custom (recentf-mode . t)
    :bind* (("C-s" . my:consult-line)
            ("C-c C-a" . consult-buffer)
            ([remap goto-line] . consult-goto-line)
            ([remap yank-pop] . consult-yank-pop))
    )

  (leaf marginalia
    :ensure t
    :global-minor-mode t)

  (leaf orderless
    :ensure t
    :custom (completion-styles . '(orderless)))

  (leaf embark
    :ensure t
    :init
    :config
    (leaf embark-consult
      :ensure t
      :after (embark consult))
    )

  ;; (leaf ivy
  ;;   :ensure t
  ;;   :leaf-defer nil
  ;;   :custom ((ivy-mode . t)
  ;;            (counsel-mode . t)
  ;;            )
  ;;   :bind ((:ivy-minibuffer-map
  ;;           ("C-w" . ivy-backward-kill-word)
  ;;           ("C-k" . ivy-kill-line)
  ;;           ("RET" . ivy-alt-done)
  ;;           ("C-h" . ivy-backward-delete-char)))
  ;;   :init
  ;;   (leaf *ivy-requirements
  ;;     :config
  ;;     (leaf migemo
  ;;       :if (executable-find "cmigemo")
  ;;       :ensure t
  ;;       :require t
  ;;       :custom
  ;;       '((migemo-user-dictionary  . nil)
  ;;         (migemo-regex-dictionary . nil)
  ;;         (migemo-options          . '("-q" "--emacs"))
  ;;         (migemo-command          . "cmigemo")
  ;;         (migemo-coding-system    . 'utf-8-unix))
  ;;       :init
  ;;       (cond
  ;;        ((and (eq system-type 'darwin)
  ;;              (file-directory-p "/usr/local/share/migemo/utf-8/"))
  ;;         (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict"))
  ;;        (t
  ;;         (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")))
  ;;       :config
  ;;       (migemo-init)
  ;;       (defun my/migemo-get-pattern-shyly (word)
  ;;         (replace-regexp-in-string
  ;;          "\\\\("
  ;;          "\\\\(?:"
  ;;          (migemo-get-pattern word)))
  ;;       (defun my/ivy--regex-migemo-pattern (word)
  ;;         (cond
  ;;          ((string-match "\\(.*\\)\\(\\[[^\0]+\\]\\)"  word)
  ;;           (concat (my/migemo-get-pattern-shyly (match-string 1 word))
  ;;                   (match-string 2 word)))
  ;;          ((string-match "\\`\\\\([^\0]*\\\\)\\'" word)
  ;;           (match-string 0 word))
  ;;          (t
  ;;           (my/migemo-get-pattern-shyly word))))
  ;;       (defun my/ivy--regex-migemo (str)
  ;;         (when (string-match-p "\\(?:[^\\]\\|^\\)\\\\\\'" str)
  ;;           (setq str (substring str 0 -1)))
  ;;         (setq str (ivy--trim-trailing-re str))
  ;;         (cdr (let ((subs (ivy--split str)))
  ;;                (if (= (length subs) 1)
  ;;                    (cons
  ;;                     (setq ivy--subexps 0)
  ;;                     (if (string-match-p "\\`\\.[^.]" (car subs))
  ;;                         (concat "\\." (my/ivy--regex-migemo-pattern (substring (car subs) 1)))
  ;;                       (my/ivy--regex-migemo-pattern (car subs))))
  ;;                  (cons
  ;;                   (setq ivy--subexps (length subs))
  ;;                   (replace-regexp-in-string
  ;;                    "\\.\\*\\??\\\\( "
  ;;                    "\\( "
  ;;                    (mapconcat
  ;;                     (lambda (x)
  ;;                       (if (string-match-p "\\`\\\\([^?][^\0]*\\\\)\\'" x)
  ;;                           x
  ;;                         (format "\\(%s\\)" (my/ivy--regex-migemo-pattern x))))
  ;;                     subs
  ;;                     ".*")
  ;;                    nil t))))))
  ;;       (defun my/ivy--regex-migemo-plus (str)
  ;;         (cl-letf (((symbol-function 'ivy--regex) #'my/ivy--regex-migemo))
  ;;           (ivy--regex-plus str))))
  ;;     (leaf swiper
  ;;       :ensure t
  ;;       :bind (([remap isearch-forward] . swiper))
  ;;       :init
  ;;       (setf (alist-get 'swiper ivy-re-builders-alist) #'my/ivy--regex-migemo-plus)
  ;;       )
  ;;     (leaf counsel
  ;;       :ensure t
  ;;       :bind (("M-s c" . counsel-ag)
  ;;              ("M-o f" . counsel-fzf)
  ;;              ("M-o r" . counsel-recentf)
  ;;              ("M-y" . counsel-yank-pop)
  ;;              ;; ([remap isearch-forward] . counsel-imenu)
  ;;              ("C-x C-r" . counsel-recentf))
  ;;       :custom `((counsel-find-file-ignore-regexp
  ;;                  p . ,(rx-to-string '(| "./" "../") 'no-group))))
  ;;     :custom ((ivy-initial-inputs-alist   . nil)
  ;;              (counsel-yank-pop-separator . "\n----------\n")))
  ;;   :config
  ;;   (leaf *other-ivy-packages
  ;;     :config
  ;;     (leaf ivy-prescient
  ;;       :when (version<= "25.1" emacs-version)
  ;;       :init
  ;;       (leaf prescient
  ;;         :custom `((prescient-aggressive-file-save . t)
  ;;                   (prescient-save-file            . ,(locate-user-emacs-file "prescient"))
  ;;                   (prescient-persist-mode         . t)))
  ;;       :ensure t
  ;;       :custom ((ivy-prescient-retain-classic-highlighting . t)
  ;;                (ivy-prescient-mode . t)))

  ;;     (leaf ivy-hydra
  ;;       :doc "Additional key bindings for Ivy"
  ;;       :ensure t
  ;;       :bind (("C-c i i" . hydra-ivy/body)))

  ;;     (leaf ivy-xref
  ;;       :doc "Ivy interface for xref results"
  ;;       :when (version<= "25.1" emacs-version)
  ;;       :ensure t
  ;;       :custom ((xref-show-xrefs-function . #'ivy-xref-show-xrefs)))

  ;;     (leaf ivy-rich
  ;;       :doc "More friendly display transformer for ivy"
  ;;       :ensure t
  ;;       :custom ((ivy-rich-mode . t)))

  ;;     ;; (leaf ivy-point-history
  ;;     ;;   :el-get SuzumiyaAoba/ivy-point-history
  ;;     ;;   :bind (("C-c b p" . ivy-point-history))
  ;;     ;;   :require t)

  ;;     (leaf all-the-icons-ivy
  ;;       :when window-system
  ;;       :after all-the-icons
  ;;       :defun (all-the-icons-ivy-setup)
  ;;       :ensure t
  ;;       :config (all-the-icons-ivy-setup))

  ;;     (leaf flx :ensure t)
  ;;     ;; Enhance M-x
  ;;     (leaf amx :ensure t)

  ;;     (leaf ivy-yasnippet
  ;;       :ensure t
  ;;       :bind ("C-c y s" . ivy-yasnippet)
  ;;       :config
  ;;       (setq ivy-yasnippet-expand-keys "smart") ; nil "always" , "smart"
  ;;                                       ; https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-ivy.el
  ;;       (advice-add #'ivy-yasnippet--preview :override #'ignore))
  ;;     )

  ;;   (leaf *ivy-integration
  ;;     :config
  ;;     ;; Integration with `projectile'
  ;;     (leaf counsel-projectile
  ;;       :ensure t
  ;;       :after projectile
  ;;       :custom ((projectile-completion-system . 'ivy)
  ;;                (counsel-projectile-mode . t)))
  ;;     ;; Integration with `magit'
  ;;     (leaf *magit-integration
  ;;       :after magit
  ;;       :custom (((magit-completing-read-function . 'ivy-completing-read))))))

  (leaf company
    :ensure t
    :leaf-defer nil
    :blackout company-mode
    :bind ((company-active-map
            ("M-n" . nil)
            ("M-p" . nil)
            ("C-s" . company-filter-candidates)
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)
            ("C-i" . company-complete-common-or-cycle))
           ;; ("C-i" . company-complete-selection))
           (company-search-map
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)))
    :custom ((company-tooltip-limit             . 12)
             (company-idle-delay                . 0)
             (company-minimum-prefix-length     . 1)
             (company-transformers              . '(company-sort-by-occurrence))
             (global-company-mode               . t)
             (company-selection-wrap-around     . t)
             (vompany-tooltip-align-annotations . t))
    :config
    (leaf company-prescient
      :ensure t
      :custom ((company-prescient-mode . t)))
    (leaf company-box
      :url "https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-company.el"
      :when (version<= "26.1" emacs-version)
      :disabled (eq window-system 'x)
      :ensure t
      :blackout company-box-mode
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
      :blackout yas-minor-mode
      :custom ((yas-indent-line . 'fixed)
               (yas-global-mode . t)
               )
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

  (leaf highlight-indent-guides
    :ensure t
    :blackout t
    :hook (((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))
    :custom (
             (highlight-indent-guides-method . 'character)  ;; fill,column,character
             (highlight-indent-guides-auto-enabled . t)  ;; automatically calculate faces.
             (highlight-indent-guides-responsive . t)
             (highlight-indent-guides-character . ?\|)))

  (leaf imenu-list
    :ensure t
    :bind (("C-z" . imenu-list-smart-toggle))
    :custom-face
    (imenu-list-entry-face-1 . '((t (:foreground "white"))))
    :custom ((imenu-list-focus-after-activation . t)
             (imenu-list-auto-resize . t))
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
    :custom ((nyan-cat-face-number . 4)
             (nyan-animate-nyancat . t))
    :hook
    ((doom-modeline-mode-hook . nyan-mode)))

  (leaf projectile
    :ensure t
    :init
    :config
    (setq projectile-mode-line-prefix " Prj")
    (projectile-mode +1)
    :custom ((projectile-mode-line-prefix . " Prj"))
    :bind (projectile-mode-map
           ("C-c p" . projectile-command-map)))

  (leaf treemacs :ensure t)

  (leaf treemacs-projectile
    :after treemacs projectile
    :ensure t)

  (leaf flycheck
    :ensure t
    :hook (prog-mode-hook . flycheck-mode)
    :custom ((flycheck-display-errors-delay . 0.3)
             )
    :config
    (leaf flycheck-inline
      :ensure t
      :hook (flycheck-mode-hook . flycheck-inline-mode))
    (leaf flycheck-color-mode-line
      :ensure t
      :hook (flycheck-mode-hook . flycheck-color-mode-line-mode)))

  (leaf add-node-modules-path
    :ensure t
    :commands add-node-modules-path)
  )
(leaf *major-mode
  :config
  (leaf *python
    :custom (python-indent-guess-indent-offset-verbose . nil)
    :config
    (leaf poetry
      :ensure t
      :hook ((elpy-mode-hook . poetry-tracking-mode)))

    (leaf elpy
      :ensure t
      :init
      (elpy-enable)
      :config
      (remove-hook 'elpy-modules 'elpy-module-highlight-indentation)
      (remove-hook 'elpy-modules 'elpy-module-flymake)
      :custom
      (elpy-rpc-python-command . "python3")
      (flycheck-python-flake8-executable . "flake8")
      (flycheck-python-mypy-config . "~/.config/mypy/config/mypy.ini")
      :bind (elpy-mode-map
             ("C-c C-r f" . elpy-format-code))
      :hook ((elpy-mode-hook . flycheck-mode))
      )

    (leaf py-isort :ensure t)

    (leaf ein :ensure t)
    )

  (leaf yaml-mode :ensure t)

  (leaf toml-mode :ensure t)

  (leaf json-reformat :ensure t)


  (leaf scss-mode
    :ensure t
    :hook ((scss-mode-hook . (lambda () (and
                                         (set (make-local-variable 'css-indent-offset) 2)
                                         (set (make-local-variable 'scss-compile-at-save) nil)
                                         )))))


  (leaf rjsx-mode
    :ensure t
    :mode ("\\.jsx\\'" "\\.js\\'")
    :custom ((indent-tabs-mode . nil)
             (js-indent-level . 2)
             (js2-strict-missing-semi-waring . nil))
    :config
    :hook (rjsx-mode-hook
           .
           (lambda ()
             (add-node-modules-path)
             (flycheck-mode t))))

  (leaf tide
    :ensure t
    :commands tide-setup)

  (leaf typescript-mode
    :ensure t
    :defun flycheck-add-mode
    :custom
    ((typescript-indent-level . 2))
    :config
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    :hook (typescript-mode-hook
           .
           (lambda ()
             (interactive)
             (add-node-modules-path)
             (flycheck-mode +1)
             (tide-setup)
             (eldoc-mode +1)
             (tide-hl-identifier +1)
             (company-mode +1)
             (setq flycheck-checker 'javascript-eslint)
             )))

  (leaf org
    :preface
    (setq my:org-directory "~/Nextcloud/org-mode/")
    (defvar org-gtd-file (concat my:org-directory "gtd.org"))
    (defvar org-memo-file (concat my:org-directory "memo.org"))
    (defun gtd ()
      (interactive)
      (find-file org-gtd-file))
    :if (file-directory-p my:org-directory)
    :bind (("C-c c" . org-capture)
           ("C-c a" . org-agenda)
           ("C-c g" . gtd))
    :advice
    (:before org-calendar-holiday
             (lambda () (require 'japanese-holidays)))
    :init
    (setq org-directory my:org-directory)
    :custom
    (
     (org-agenda-files . (list org-directory))
     (org-startup-indent . t)
     (org-hide-leading-stars . t)
     (org-return-follows-link . t)
     (org-log-done . t)
     (org-todo-keywords . '((sequence "TODO(t)" "IN PROGRESS(i)" "|" "DONE(d)")
                            (sequence "WAITING(w@/!)" "CANCELLED(c@/!)" "SOMEDAY(s)")))
     (org-todo-keyword-faces . '(("TODO" :foreground "red" :weight bold)
                                 ("STARTED" :foreground "cornflower blue" :weight bold)
                                 ("DONE" :foreground "green" :weight bold)
                                 ("WAITING" :foreground "orange" :weight bold)
                                 ("CANCELLED" :foreground "green" :weight bold)))
     )
    )
  (leaf org-capture
    :leaf-defer t
    :after org
    :commands (org-capture)
    :config
    (setq org-capture-templates `(
                                  ("i" " Inbox" entry (file+headline org-gtd-file "Inbox")
                                   "** %^{Brief Description}")
                                  ("m" " Memo" entry (file ,org-memo-file)
                                   "* %U %i %?")
                                  )))

  (leaf web-mode
    :ensure t
    :after flycheck
    :defun flycheck-add-mode
    :mode ("\\.tsx\\'" "\\.css\\'" "\\.json\\'" "\\.p?html?\\'" "\\.php\\'")
    :config
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    :custom
    ((web-mode-markup-indent-offset . 2)
     (web-mode-css-indent-offset . 2)
     (web-mode-code-indent-offset . 2)
     (web-mode-comment-style . 2)
     (web-mode-style-padding . 1)
     (web-mode-script-padding . 1)
     (web-mode-enable-auto-closing . t)
     (web-mode-enable-auto-pairing . t)
     (web-mode-auto-close-style . 2)
     (web-mode-tag-auto-close-style . 2)
     (indent-tabs-mode . nil)
     (tab-width . 2))
    :hook (web-mode-hook
           .
           (lambda ()
             (interactive)
             (when (string-equal "tsx" (file-name-extension buffer-file-name))
               (add-node-modules-path)
               (tide-setup)
               (flycheck-mode +1)
               (setq flycheck-checker 'javascript-eslint)
               (eldoc-mode +1)
               (tide-hl-identifier-mode +1)
               (company-mode +1)
               )))
    )

  (leaf markdown-mode
    :ensure t
    :mode ("\\.md\\'")
    :hook ((markdown-mode-hook . (lambda () (setq tab-width 2)))))

  (leaf *docker-mode
    :config
    (leaf docker              :ensure t)
    (leaf dockerfile-mode     :ensure t)
    (leaf docker-compose-mode :ensure t)
    (leaf docker-tramp        :ensure t))
  )

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
    (add-hook 'term-exec-hook 'set-no-process-query-on-exit))
  )
