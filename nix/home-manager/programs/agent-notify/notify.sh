#!/usr/bin/env sh
set -eu

title=${1:-Agent}
shift || true
message=${*:-Hook completed}

host=$(hostname -s 2>/dev/null || hostname 2>/dev/null || printf 'unknown-host')
context="host=${host}"

if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
  tmux_context=$(tmux display-message -p '#S:#I.#P #W' 2>/dev/null || true)
  if [ -n "$tmux_context" ]; then
    context="${context} tmux=${tmux_context}"
  fi
fi

context="${context} cwd=${PWD}"
message=$(printf '%s\n%s' "$message" "$context")

case ${AGENT_NOTIFY_TRANSPORT:-uservar} in
  osc9)
    osc=$(printf '\033]777;notify;%s;%s\033\\' "$title" "$message")
    ;;
  uservar)
    payload=$(printf '%s\n%s' "$title" "$message" | base64 | tr -d '\n')
    osc=$(printf '\033]1337;SetUserVar=agent_notify=%s\a' "$payload")
    ;;
  *)
    printf 'notify.sh: unsupported AGENT_NOTIFY_TRANSPORT: %s\n' "$AGENT_NOTIFY_TRANSPORT" >&2
    exit 2
    ;;
esac

emit() {
  if [ -n "${TMUX:-}" ]; then
    printf '\033Ptmux;\033%s\033\\' "$osc"
  else
    printf '%s' "$osc"
  fi
}

if [ -w /dev/tty ]; then
  emit > /dev/tty
elif [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
  pane_tty=$(tmux display-message -p '#{pane_tty}' 2>/dev/null || true)
  if [ -n "$pane_tty" ] && [ -w "$pane_tty" ]; then
    emit > "$pane_tty"
  else
    emit
  fi
else
  emit
fi
