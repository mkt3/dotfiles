#!/usr/bin/env bash

set -euo pipefail

# Keep these settings imperative because defaults(1) must merge them into
# dictionaries that can also contain entries managed outside this repository.

# Disable Spotlight's Cmd+Space because AeroSpace uses it for fullscreen.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"

# Disable the macOS input-source shortcuts because macSKK manages input.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"

# Disable the dictation shortcut.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 164 "<dict><key>enabled</key><false/></dict>"
