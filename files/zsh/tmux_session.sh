#!/usr/bin/env bash

function get_source_list() {
    local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" opened="\ue5fe" unopened="\ue5ff"
    local session_list=($(tmux list-sessions -F "#S" 2>/dev/null))

    candidate_list=($(ghq list | sort) "main_session")
    for repo in "${candidate_list[@]}"; do
        array=( `echo $repo | tr -s '/' ' '`)
        session=${array[`expr ${#array[@]}-1`]//[:. ]/-}
        color="$blue"
        icon="$unopened"

        if printf '%s\n' "${session_list[@]}" | grep -qx "$session"; then
            color="$green"
            icon="$opened"
        fi
        printf "$color$icon %s$reset\n" "$repo"
    done
}

function get_selected_source() {
    local root="$(ghq root)"
    get_source_list | $HOME/.local/share/fzf/bin/fzf | cut -d' ' -f2-
}

function set_session() {
    local selected_source="$(get_selected_source)"
    
    if [ -z "$selected_source" ]; then
        return
    fi

    local repo_dir

    if [ $selected_source == "main_session" ]; then
        repo_dir=$HOME
    else
        repo_dir="$(ghq list --exact --full-path "$selected_source")"
    fi
    local array=( `echo $selected_source | tr -s '/' ' '`)
    local session_name=${array[`expr ${#array[@]}-1`]//[:. ]/-}
    if [[ -z "$TMUX" ]]; then
        tmux new-session -A -s "$session_name" -c $repo_dir 2> /dev/null
    elif [ "$(tmux display-message -p "#S")" != "$session_name" ]; then
        echo $repo_dir
        tmux new-session -d -s "$session_name" -c $repo_dir 2> /dev/null
        tmux switch-client -t "$session_name"
    fi
}

set_session
