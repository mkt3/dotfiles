#!/bin/sh

FILENAME=$1

if grep -q [ぁ-ん] $FILENAME; then
    TEXTLINTRC="${HOME}/.config/textlint/textlintrc_ja.json"
else
    TEXTLINTRC="${HOME}/.config/textlint/textlintrc_en.json"
fi


textlint --format unix --config ${TEXTLINTRC} ${FILENAME}
