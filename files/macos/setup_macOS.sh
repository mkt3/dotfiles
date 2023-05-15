#!/usr/bin/env bash

##
# macOSの設定
##

# keyboard
## リピート入力までの時間
defaults write -g InitialKeyRepeat -int 15
## キーのリピート
defaults write -g KeyRepeat -int 2

# trackpad
## 軌跡の速さ
defaults write -g com.apple.trackpad.scaling 3
## スクロールの速さ
defaults write -g com.apple.trackpad.scrolling 1
## 3本指ドラッグの有効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

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
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
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
## 「Emoji & Symbols」のショートカットキーをctrl + shift + f12へ
defaults write "Apple Global Domain" NSUserKeyEquivalents -dict-add "Emoji & Symbols" -string "@$\\Uf70f"
## 「絵文字と記号」のショートカットキーをctrl + shift + f12へ
defaults write "Apple Global Domain" NSUserKeyEquivalents -dict-add "\\U7d75\\U6587\\U5b57\\U3068\\U8a18\\U53f7" -string "@$\\Uf70f"
## 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
## 検索時にデフォルトでカレントディレクトリを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
## デフォルトをカラム表示
defaults write com.apple.finder FXPreferredViewStyle clmv

## サイドバーの表示
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true

## Disable animation for yabai
## https://github.com/koekeishiya/yabai/wiki/Tips-and-tricks#fix-folders-opened-from-desktop-not-tiling
defaults write com.apple.finder DisableAllAnimations -bool true

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

## Disable Input Sources 
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"

## Disable Dictation Shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 164 "<dict><key>enabled</key><false/></dict>"

# スペルの訂正を無効にする
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# 自動大文字の無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# メニューバー
## バッテリー残量の％表記
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
## 日付、曜日、時間の表記
defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm'
## menu bar icon
defaults write com.apple.systemuiserver menuExtras -array \
         "/System/Library/CoreServices/Menu Extras/Clock.menu" \
         "/System/Library/CoreServices/Menu Extras/Battery.menu" \
         "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
         "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
         "/System/Library/CoreServices/Menu Extras/Displays.menu"

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
## 起動中のアプリのみ表示
defaults write com.apple.dock persistent-apps -array
# Dockをすぐに表示
defaults write com.apple.dock autohide-delay -float 0
killall Dock

## ファイアーウォールを有効
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# キャプチャ
## キャプチャの保存場所を変更
defaults write com.apple.screencapture location ~/Downloads
## キャプチャのプレフィックスを変更
defaults write com.apple.screencapture name "ss_"

# TextEdit
## RichTextの無効化
defaults write com.apple.TextEdit RichText -int 0
## UTF-8で保存
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

## Time MachineからTime Machine用のSMBフォルダを参照できるように
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1

## システムの透過設定を無効化
#defaults write com.apple.universalaccess reduceTransparency 1

## Dictationの無効化して、ダイアログを再表示させない
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 1
