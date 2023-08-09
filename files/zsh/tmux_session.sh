#!/usr/bin/env bash

function get_source_list() {
    local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" opened="\ue5fe" unopened="\ue5ff"
    local session_list
    mapfile -t session_list < <(tmux list-sessions -F "#S" 2>/dev/null)

    local candidate_list
    local session_name
    local color
    local icon
    mapfile -t candidate_list < <(ghq list | sort)
    candidate_list+=("main_session")
    for repo in "${candidate_list[@]}"; do
        session_name=$(basename "$repo" | sed 's/\./_/g')
        color="$blue"
        icon="$unopened"

        if printf '%s\n' "${session_list[@]}" | grep -qx "$session_name"; then
            color="$green"
            icon="$opened"
        fi
        printf "$color$icon %s$reset\n" "$repo"
    done
}

function get_selected_source() {
    get_source_list | "${HOME}/.local/share/fzf/bin/fzf" --height 100% | cut -d' ' -f2-
}

function set_session() {
    local selected_source
    selected_source="$(get_selected_source)"

    if [ -z "$selected_source" ]; then
        return
    fi

    local repo_dir

    if [ "$selected_source" == "main_session" ]; then
        repo_dir=$HOME
    else
        repo_dir="$(ghq list --exact --full-path "$selected_source")"
    fi

    local session_name
    session_name=$(basename "$selected_source" | sed 's/\./_/g')

    if [[ -z "$TMUX" ]]; then
        tmux new-session -A -s "$session_name" -c "$repo_dir" 2> /dev/null
    elif [ "$(tmux display-message -p "#S")" != "$session_name" ]; then
        tmux new-session -d -s "$session_name" -c "$repo_dir" 2> /dev/null
        tmux switch-client -t "$session_name"
    fi
}

set_session
