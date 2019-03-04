;;====================================================================
;; ddskk
;;====================================================================
(use-package skk
  :straight ddskk
  :config
  ;; 入力システムをSKKに設定
  (set-input-method "japanese-skk")
  (bind-key* "\C-xj" 'skk-mode)
  (setq skk-jisyo (locate-user-emacs-file "ddskk.d/skk-jisyo"))
  (setq skk-backup-jisyo (locate-user-emacs-file "ddskk.d/skk-jisyo.BAK"))
  (setq skk-record-file (locate-user-emacs-file "ddskk.d/skk-record"))
  (setq skk-keep-record t)
  ;; 変換時に改行でも確定
  (setq skk-egg-like-newline t)
  ;; BSを押すと一つ前の候補を表示
  (setq skk-delete-implies-kakutei nil)

  ;; "「"を入力したら"」"も自動で挿入する
  (setq skk-auto-insert-paren t)
  ;; 句読点は , . を使う
  ;; (setq-default skk-kutouten-type 'en)
  ;;変換時のundo情報を記録しない
  (setq skk-undo-kakutei-word-only t)
  ;; モードラインの表示
  (skk-modify-indicator-alist 'latin "[a]")
  (skk-modify-indicator-alist 'hiragana "[あ]")
  (skk-modify-indicator-alist 'katakana "[ア]")
  (skk-modify-indicator-alist 'jisx0208-latin "[Ａ]")
  ;; (skk-modify-indicator-alist 'jisx0201n "[bb]")

  ;; 半角カナ
  ;; (setq skk-use-jisx0201-input-method t)
  ;; インジケータに色を付けない
  (setq skk-indicator-use-cursor-color nil)
  ;; 注釈の利用
  (setq skk-show-annotation t)
  ;; 変換候補の表示位置
  ;;(setq skk-show-tooltip nil)
  (setq skk-show-candidates-always-pop-to-buffer t)
  ;; 候補表示件数を2列に
  (setq skk-henkan-show-candidates-rows 2)
  (setq skk-henkan-strict-okuri-precedence t) ; 送り仮名が厳密に正しい候補を優先して表示
  (require 'skk-hint); ヒント
  (add-hook 'skk-load-hook ; 自動的に入力モードを切り替え
            (lambda ()
              (require 'context-skk)))

  ;; 動的候補表示
  (setq skk-dcomp-activate t) ; 動的補完
  (setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
  (setq skk-dcomp-multiple-rows 10) ; 動的補完の候補表示件数
  ;; 動的補完の複数表示群のフェイス
  (set-face-foreground 'skk-dcomp-multiple-face "Black")
  (set-face-background 'skk-dcomp-multiple-face "LightGoldenrodYellow")
  (set-face-bold-p 'skk-dcomp-multiple-face nil)
  ;; 動的補完の複数表示郡の補完部分のフェイス
  (set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
  (set-face-bold-p 'skk-dcomp-multiple-trailing-face nil)
  ;; 動的補完の複数表示郡の選択対象のフェイス
  (set-face-foreground 'skk-dcomp-multiple-selected-face "White")
  (set-face-background 'skk-dcomp-multiple-selected-face "LightGoldenrod4")
  (set-face-bold-p 'skk-dcomp-multiple-selected-face nil)
  ;; 動的補完時に下で次の補完へ
  (define-key skk-j-mode-map (kbd "<down>") 'skk-completion-wrapper)

  ;; isearch
  (setq skk-isearch-mode-enable nil)

  (defun skk-mode-invoke-if-not-invoked ()
    (interactive)

    (if (not (boundp 'skk-mode))
        (progn
          (skk-mode)
          (skk-latin-mode t)
          )
      (if (not skk-mode)
          (skk-latin-mode t)
        )))

  (add-hook 'find-file-hooks (lambda () (skk-mode-invoke-if-not-invoked)))
  (add-hook 'org-mode-hook (lambda () (skk-mode-invoke-if-not-invoked)))

  )
