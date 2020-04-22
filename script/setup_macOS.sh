#!/bin/bash

# keyboard
## リピート入力までの時間
defaults write -g InitialKeyRepeat -int 15
# キーのリピート
defaults write -g KeyRepeat -int 2

# trackpad
## スクロールの速さ
defaults write -g com.apple.trackpad.scaling 3

# Finder
## フルパス表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
## ステータスバー表示
defaults write com.apple.finder ShowStatusBar -bool true
## パスバー表示
defaults write com.apple.finder ShowPathbar -bool true
## 新規ウィンドウをホームディレクトリで開く
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
## ネットワークドライブやUSBメモリでの.DS_Storeの作成抑止
defaults write com.apple.desktopservices DSDontWriteNetworkStores True
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# マウントされたディスクがあったら、自動的に新しいウィンドウを開く
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
## 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
## 保存ダイアログを詳細設定で表示
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -boolean true
## 「ゴミ箱に入れる」のショートカットキーをctrl + dへ
defaults write com.apple.Finder NSUserKeyEquivalents -dict-add "ゴミ箱に入れる" -string "^d"
# 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# 検索時にデフォルトでカレントディレクトリを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

## サイドバーから「最近の項目」を削除
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false

defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true

killall Finder

# コントロール間のフォーカス移動をキーボードで
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
# 次のウィンドウを操作対象へ
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

# Spotlight
## 「Spotlight検索を表示」を無効化
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"

## 「Finderの検索ウインドウを表示」を無効化
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"

# スペルの訂正を無効にする
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# 自動大文字の無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# メニューバー
## バッテリー残量の％表記
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
## 日付、曜日、時間の表記
defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm'
## bluetoothの表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true

# Dock
## Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true
## Dockの拡大機能を有効化
defaults write com.apple.dock magnification -bool true
## アイコンサイズ
defaults write com.apple.dock tilesize -int 43
## 拡大時のアイコンサイズ
defaults write com.apple.dock largesize -int 96
## 最近つかったアプリケーションを非表示
defaults write com.apple.dock show-recents -bool false
# Dockをすぐに表示
defaults write com.apple.dock autohide-delay -float 0
killall Dock

## ファイアーウォールを有効
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# TextEdit
## RichTextの無効化
defaults write com.apple.TextEdit RichText -int 0
## UTF-8で保存
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
