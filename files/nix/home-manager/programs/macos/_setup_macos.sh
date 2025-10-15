#!/usr/bin/env bash

##
# macOSの設定
##

# Finder
## 新規ウィンドウをホームディレクトリで開く
/usr/bin/defaults write com.apple.finder NewWindowTarget -string "PfLo"
/usr/bin/defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
## ネットワークドライブやUSBメモリでの.DS_Storeの作成抑止
/usr/bin/defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
/usr/bin/defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# マウントされたディスクがあったら、自動的に新しいウィンドウを開く
/usr/bin/defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
/usr/bin/defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

## 「Move to Trash」のショートカットキーをctrl + dへ
/usr/bin/defaults write com.apple.Finder NSUserKeyEquivalents -dict-add "Move to Trash" -string "^d"
## 「Emoji & Symbols」のショートカットキーをctrl + shift + f12へ
/usr/bin/defaults write -g NSUserKeyEquivalents -dict-add "Emoji & Symbols" -string "@$\\Uf70f"
## 「絵文字と記号」のショートカットキーをctrl + shift + f12へ
/usr/bin/defaults write -g NSUserKeyEquivalents -dict-add "\\U7d75\\U6587\\U5b57\\U3068\\U8a18\\U53f7" -string "@$\\Uf70f"

## サイドバーの表示
/usr/bin/defaults write com.apple.finder ShowRecentTags -bool false
/usr/bin/defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false
/usr/bin/defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false
/usr/bin/defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
/usr/bin/defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true

## Disable animation
## https://github.com/koekeishiya/yabai/wiki/Tips-and-tricks#fix-folders-opened-from-desktop-not-tiling
/usr/bin/defaults write com.apple.finder DisableAllAnimations -bool true

/usr/bin/killall Finder

# 次のウィンドウを操作対象へ
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"

# Spotlight
## 「Spotlight検索を表示」を無効化
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
## 「Finderの検索ウインドウを表示」を無効化
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"

## Disable Input Sources
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"

## Disable Dictation Shortcut
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 164 "<dict><key>enabled</key><false/></dict>"

# 自動テキスト補完を無効
/usr/bin/defaults write -g NSAutomaticTextCompletionEnabled -int 0


# メニューバー
/usr/bin/defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false # Siri 非表示
/usr/bin/defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true # battery 表示
/usr/bin/defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true # bluetooth 表示
/usr/bin/defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool true # clock 表示
/usr/bin/defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true # volume 表示
## Show menu bar background
/usr/bin/defaults write -g SLSMenuBarUseBlurredAppearance -int 1


# キャプチャ
## キャプチャのプレフィックスを変更
/usr/bin/defaults write com.apple.screencapture name "ss_"

# TextEdit
## RichTextの無効化
/usr/bin/defaults write com.apple.TextEdit RichText -int 0
## UTF-8で保存
/usr/bin/defaults write com.apple.TextEdit PlainTextEncoding -int 4
/usr/bin/defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

## Time MachineからTime Machine用のSMBフォルダを参照できるように
/usr/bin/defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1

## Reduce motion
/usr/bin/defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

## Dictationの無効化して、ダイアログを再表示させない
/usr/bin/defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 1

# Click wallpaper to show desktop items – Only in Stage Manager
/usr/bin/defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Enable "Automatically switch to a ocument's input source"
/usr/bin/defaults write com.apple.HIToolbox AppleGlobalTextInputProperties -dict TextInputGlobalPropertyPerContextInput -int 1

# Display app switcher to all display
/usr/bin/defaults write com.apple.Dock appswitcher-all-displays -bool true

# Hide desktop widgets
/usr/bin/defaults write com.apple.WindowManager StandardHideWidgets -bool true
