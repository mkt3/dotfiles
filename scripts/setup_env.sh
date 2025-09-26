#!/usr/bin/env bash

set -eu
set -o pipefail

ask_prompt() {
    local prompt="$1"
    local result_var="$2"
    local answer

    while true; do
        read -r -p "$prompt: " answer
        if [[ -n "$answer" ]]; then
            eval "$result_var=\"$answer\""
            break
        fi
        echo "Input cannot be empty. Please enter a value."
    done
}

ask_yes_no() {
    local prompt="$1"
    local result_var="$2"
    local answer

    while true; do
        read -r -p "$prompt (y/n): " answer
        case "$answer" in
            [Yy]* ) eval "$result_var=\"y\""; break;;
            [Nn]* ) eval "$result_var=\"n\""; break;;
            * ) echo "Please answer y or n.";;
        esac
    done
}


echo "--- Environment Setup Wizard ---"

ask_prompt "What's the unique hostname for this system configuration" host_name

ask_yes_no "Is this a development environment? (Installs coding/tooling packages)" is_dev
ask_yes_no "Is this a GUI environment? (Installs desktop/window manager packages)" is_gui

echo "Saving environment variables to $ENV_FILE"

{
    echo "HOSTNAME_ENV=${host_name}"
    echo "DEV_ENV=${is_dev}"
    echo "GUI_ENV=${is_gui}"
} > "$ENV_FILE"

echo "Setup complete."
