#!/usr/bin/env bash

##
# macOSの設定
##

# Finder
## 新規ウィンドウをホームディレクトリで開く
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
## ネットワークドライブやUSBメモリでの.DS_Storeの作成抑止
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# マウントされたディスクがあったら、自動的に新しいウィンドウを開く
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

## 「Move to Trash」のショートカットキーをctrl + dへ
defaults write com.apple.Finder NSUserKeyEquivalents -dict-add "Move to Trash" -string "^d"
## 「Emoji & Symbols」のショートカットキーをctrl + shift + f12へ
defaults write -g NSUserKeyEquivalents -dict-add "Emoji & Symbols" -string "@$\\Uf70f"
## 「絵文字と記号」のショートカットキーをctrl + shift + f12へ
defaults write -g NSUserKeyEquivalents -dict-add "\\U7d75\\U6587\\U5b57\\U3068\\U8a18\\U53f7" -string "@$\\Uf70f"

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

# 自動テキスト補完を無効
defaults write -g NSAutomaticTextCompletionEnabled -int 0

# メニューバー
defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false # Siri 非表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true # battery 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true # bluetooth 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool true # clock 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true # volume 表示

# キャプチャ
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

## Reduce motion
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

## Dictationの無効化して、ダイアログを再表示させない
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 1

# Click wallpaper to show desktop items – Only in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
