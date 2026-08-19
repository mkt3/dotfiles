#!/usr/bin/env bash

set -euo pipefail

# Clone the private shared dictionary only when GitHub CLI authentication is
# already available. Never start an interactive login from Home Manager.
skk_dict_dir="$HOME/workspace/ghq/github.com/mkt3/skk-dict"
if [[ ! -e "$skk_dict_dir" ]] && command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  mkdir -p "${skk_dict_dir%/*}"
  if ! gh repo clone mkt3/skk-dict "$skk_dict_dir"; then
    echo "shared SKK dictionary: skipping clone because skk-dict could not be cloned" >&2
  fi
fi

if [[ -d "$skk_dict_dir/.git" ]]; then
  if [[ -z "$(git -C "$skk_dict_dir" status --porcelain)" ]]; then
    if ! GIT_TERMINAL_PROMPT=0 git -C "$skk_dict_dir" pull --rebase; then
      echo "shared SKK dictionary: skipping pull because skk-dict could not be updated" >&2
    fi
  else
    echo "shared SKK dictionary: skipping pull because skk-dict has local changes; review, commit, and push them before running make again" >&2
  fi
fi
