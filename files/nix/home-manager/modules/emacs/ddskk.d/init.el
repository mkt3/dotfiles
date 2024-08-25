;;; init --- SKK init file  -*- mode: emacs-lisp; coding: utf-8 -*-

;; skk server dict
;; (setq skk-server-host "localhost")
;; (setq skk-server-portnum 1178)

;; sticky shift
(setq skk-sticky-key ";")

;;; 変換時に改行でも確定
(setq skk-egg-like-newline t)

;; BSを押すと一つ前の候補を表示
(setq skk-delete-implies-kakutei nil)

;; "「"を入力したら"」"も自動で挿入する
(setq skk-auto-insert-paren t)

;; 句読点は , . を使う
;(setq-default skk-kutouten-type 'en)

;;変換時のundo情報を記録しない
(setq skk-undo-kakutei-word-only t)

;; モードラインの表示
(setq skk-latin-mode-string "[_A]")
(setq skk-hiragana-mode-string "[あ]")
(setq skk-katakana-mode-string "[ア]")
(setq skk-jisx0208-latin-mode-string "[Ａ]")
(setq skk-jisx0201-mode-string "[_ｱ]")
(setq skk-abbrev-mode-string "[aA]")

;; カーソル付近にモード切り替えを表示する
(setq skk-show-mode-show t); M-x skk-show-mode でトグル可。
(set-face-background 'skk-show-mode-inline-face "#272C36")

;; 半角カナ
(setq skk-use-jisx0201-input-method t)

;; インジケータに色を付ける
(setq skk-use-color-cursor t)
(setq skk-indicator-use-cursor-color t)

;; 注釈は利用しない
(setq skk-show-annotation nil)

;; 変換候補の表示位置
(setq skk-show-inline 'vertical)
(when skk-show-inline
  (setq skk-inline-show-face nil
	      skk-inline-show-background-color "#272C36"
        skk-inline-show-background-color-odd "#272C36"))
(setq skk-show-candidates-always-pop-to-buffer t)

;; 候補表示件数を2列に
(setq skk-henkan-show-candidates-rows 2)
;; 候補一覧を表示するまでの `skk-start-henkan-char' を打鍵する回数
(setq skk-show-candidates-nth-henkan-char 2)
;; 送り仮名が厳密に正しい候補を優先して表示
(setq skk-henkan-strict-okuri-precedence t)

;; 動的候補表示
(setq skk-dcomp-activate t) ; 動的補完
(setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
(setq skk-dcomp-multiple-rows 10) ; 動的補完の候補表示件数
;; 動的補完の複数表示群のフェイス
(set-face-foreground 'skk-dcomp-multiple-face "White")
(set-face-background 'skk-dcomp-multiple-face "#272C36")
(set-face-bold-p 'skk-dcomp-multiple-face nil)
;; 動的補完の複数表示郡の補完部分のフェイス
(set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
(set-face-bold-p 'skk-dcomp-multiple-trailing-face nil)
;; 動的補完の複数表示郡の選択対象のフェイス
(set-face-foreground 'skk-dcomp-multiple-selected-face "White")
(set-face-background 'skk-dcomp-multiple-selected-face "#5E81AC")
(set-face-bold-p 'skk-dcomp-multiple-selected-face nil)

;; 変換の学習
(require 'skk-study)

;; 複数の Emacsen を起動して個人辞書を共有する
(setq skk-share-private-jisyo t)

;; 単語登録／単語削除のたびに個人辞書を保存する
(setq skk-save-jisyo-instantly t)
