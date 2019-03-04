(use-package company
  :straight company
  :straight company-jedi
  :init
  (global-company-mode) ; 全バッファで有効にする
  (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 1) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  ;; yasnippetとの連携
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  :bind (("C-M-i" . company-complete)
         :map company-active-map
         ("C-n" . company-select-next) ;; C-n, C-pで補完候補を次/前の候補を選択
         ("C-p" . company-select-previous)
         ("C-s" . company-filter-candidates) ;; C-sで絞り込む
         ("C-i" . company-complete-selection) ;; C-iで候補を設定
         ("C-f" . company-complete-selection) ;; C-fで候補を設定
         ("C-M-h" . company-show-doc-buffer) ;; ドキュメント表示はC-Shift-h
         :map company-search-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         )
  )
