#!/usr/bin/env bash
set -e
set -o pipefail

# pam_tidの存在チェック（間違えてLinux環境などで実行されたら中断する）
test -f /usr/lib/pam/pam_tid.so.2 || exit 1

# sudoでTouchIDが使えるようにする
if ! grep -Eq '^auth\s.*\spam_tid\.so$' /etc/pam.d/sudo; then
  ( set -e; set -o pipefail
    # 最初の auth として pam_tid.so を追加
    pam_sudo=$(awk 'fixed||!/^auth /{print} !fixed&&/^auth/{print "auth       sufficient     pam_tid.so";print;fixed=1}' /etc/pam.d/sudo)
    sudo tee /etc/pam.d/sudo <<<"$pam_sudo"
  )
fi

# tmux内のsudoでもTouchIDが使えるようにする
if ! grep -Eq '^auth\s.*\spam_reattach\.so$' /etc/pam.d/sudo; then
  ( set -e; set -o pipefail
    # pam_reattach.so が無ければ入れる
    if [[ ! -x /usr/local/lib/pam/pam_reattach.so ]]; then
      type cmake 2>/dev/null || brew install cmake
      cd $(mktemp -d "${TMPDIR:-/tmp}/tmp.${1:-pam_reattach}.XXXXXXXXXX")
      git clone https://github.com/fabianishere/pam_reattach.git .
      cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
      make install
    fi
    # pam_tid.so の手前に pam_reattach.so を追加
    pam_sudo=$(awk 'fixed||!/^auth .* pam_tid.so$/{print} !fixed&&/^auth/{print "auth       optional       pam_reattach.so";print;fixed=1}' /etc/pam.d/sudo)
    sudo tee /etc/pam.d/sudo <<<"$pam_sudo"
  )
fi
