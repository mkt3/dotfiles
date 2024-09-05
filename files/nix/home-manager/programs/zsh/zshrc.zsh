# https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache

# source command override technique
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}

ensure_zcompiled "${ZDOTDIR}/.zshrc"

# sheldon cache technique
sheldon_cache="${SHELDON_CONFIG_DIR}/sheldon.zsh"
sheldon_toml="${SHELDON_CONFIG_DIR}/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
    sheldon source > "$sheldon_cache"
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

source "${ZDOTDIR}/no_defer.zsh"
zsh-defer source "${ZDOTDIR}/defer.zsh"
zsh-defer unfunction source
