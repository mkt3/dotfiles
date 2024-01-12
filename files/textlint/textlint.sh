#!/usr/bin/env bash

set -eu
set -o pipefail

FILENAME="$1"
EXTENSION="${FILENAME##*.}"

determine_textlintrc() {
    if grep -q "[ぁ-ん]" "$1"; then
        echo "${HOME}/.config/textlint/textlintrc/textlintrc_ja.json"
    else
        echo "${HOME}/.config/textlint/textlintrc/textlintrc_en.json"
    fi
}

TEXTLINTRC=$(determine_textlintrc "$FILENAME")

ARGS=(--format unix --config "$TEXTLINTRC" "$FILENAME")

if [ "$EXTENSION" = "org" ]; then
    ARGS+=(--plugin org)
fi

textlint "${ARGS[@]}"
