#!/usr/bin/env bash

set -euo pipefail

# Keep these settings imperative because defaults(1) must merge them into
# dictionaries that can also contain entries managed outside this repository.

# Clone the private shared dictionary only when GitHub CLI authentication is
# already available. Never start an interactive login from Home Manager.
skk_dict_dir="$HOME/workspace/ghq/github.com/mkt3/skk-dict"
if [[ ! -e "$skk_dict_dir" ]] && command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  /bin/mkdir -p "${skk_dict_dir%/*}"
  if ! gh repo clone mkt3/skk-dict "$skk_dict_dir"; then
    echo "macSKK: skipping shared dictionary because skk-dict could not be cloned" >&2
  fi
fi

if [[ -d "$skk_dict_dir/.git" ]]; then
  if [[ -z "$(git -C "$skk_dict_dir" status --porcelain)" ]]; then
    if ! GIT_TERMINAL_PROMPT=0 git -C "$skk_dict_dir" pull --rebase; then
      echo "macSKK: skipping shared dictionary update because skk-dict could not be pulled" >&2
    fi
  else
    echo "macSKK: skipping shared dictionary update because skk-dict has local changes" >&2
  fi
fi

# macSKK cannot read a dictionary through a symbolic link outside its sandbox.
# Deploy a regular-file copy from the Git-managed source when it is available.
shared_skk_source="$skk_dict_dir/SKK-JISYO.shared"
macskk_dictionary_dir="$HOME/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries"
macskk_shared_skk="$macskk_dictionary_dir/SKK-JISYO.shared"

if [[ -f "$shared_skk_source" ]]; then
  /bin/mkdir -p "$macskk_dictionary_dir"
  if [[ -L "$macskk_shared_skk" ]]; then
    /bin/rm "$macskk_shared_skk"
  fi
  if [[ ! -f "$macskk_shared_skk" ]] || ! /usr/bin/cmp -s "$shared_skk_source" "$macskk_shared_skk"; then
    /bin/cp "$shared_skk_source" "$macskk_shared_skk"
  fi
fi

# Disable Spotlight's Cmd+Space because AeroSpace uses it for fullscreen.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"

# Disable the macOS input-source shortcuts because macSKK manages input.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"

# Disable the dictation shortcut.
/usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 164 "<dict><key>enabled</key><false/></dict>"
