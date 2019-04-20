(setq skk-keep-record t)
;; 変換時に改行でも確定
(setq skk-egg-like-newline t)
;; BSを押すと一つ前の候補を表示
(setq skk-delete-implies-kakutei nil)
;; stciky-shift
(setq skk-sticky-key ";")
;; "「"を入力したら"」"も自動で挿入する
(setq skk-auto-insert-paren t)
;; 句読点は , . を使う
;; (setq-default skk-kutouten-type 'en)
;;変換時のundo情報を記録しない
(setq skk-undo-kakutei-word-only t)
;;モードラインの表示
(setq skk-latin-mode-string "[_A]")
(setq skk-hiragana-mode-string "[あ]")
(setq skk-katakana-mode-string "[ア]")
(setq skk-jisx0208-latin-mode-string "[Ａ]")
(setq skk-jisx0201-mode-string "[_ｱ]")
(setq skk-abbrev-mode-string "[aA]")
;; インジケータに色を付けない
(setq skk-indicator-use-cursor-color nil)
;; 半角カナ
(setq skk-use-jisx0201-input-method t)
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
