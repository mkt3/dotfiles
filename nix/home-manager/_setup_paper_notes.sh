#!/usr/bin/env bash

set -euo pipefail

# Clone the private paper-notes repository only when GitHub CLI authentication
# is already available. Never start an interactive login from Home Manager.
paper_notes_dir="$HOME/workspace/ghq/github.com/mkt3/paper-notes"

if [[ ! -e "$paper_notes_dir" ]] && command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  mkdir -p "${paper_notes_dir%/*}"
  if ! gh repo clone mkt3/paper-notes "$paper_notes_dir"; then
    echo "paper notes: skipping clone because paper-notes could not be cloned" >&2
  fi
fi

if [[ -e "$paper_notes_dir" && ! -d "$paper_notes_dir/.git" ]]; then
  echo "paper notes: skipping update because paper-notes exists but is not a Git repository" >&2
elif [[ -d "$paper_notes_dir/.git" ]]; then
  if [[ -z "$(git -C "$paper_notes_dir" status --porcelain)" ]]; then
    if ! GIT_TERMINAL_PROMPT=0 git -C "$paper_notes_dir" pull --rebase; then
      echo "paper notes: skipping pull because paper-notes could not be updated" >&2
    fi
  else
    echo "paper notes: skipping pull because paper-notes has local changes; review, commit, and push them before running make again" >&2
  fi
fi

if [[ -n "${ORG_ROAM_DIR:-}" && -d "$paper_notes_dir/papers" && -d "$ORG_ROAM_DIR" ]]; then
  paper_link="$ORG_ROAM_DIR/reference/paper"
  mkdir -p "${paper_link%/*}"

  if [[ -L "$paper_link" ]]; then
    if [[ "$(readlink "$paper_link")" != "$paper_notes_dir/papers" ]]; then
      echo "paper notes: existing Org-roam link points elsewhere: $paper_link" >&2
    fi
  elif [[ -e "$paper_link" ]]; then
    echo "paper notes: skipping Org-roam link because the path already exists: $paper_link" >&2
  elif ! ln -s "$paper_notes_dir/papers" "$paper_link"; then
    echo "paper notes: could not create the Org-roam link: $paper_link" >&2
  fi
fi
