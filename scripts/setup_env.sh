#!/usr/bin/env bash

set -eu
set -o pipefail


ask_yes_no() {
    local prompt=$1
    local result_var=$2
    local answer

    while true; do
        read -p "$prompt (y/n): " answer
        case "$answer" in
            [Yy]* ) eval "$result_var"="y"; break;;
            [Nn]* ) eval "$result_var"="n"; break;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

ask_hostname() {
    local prompt=$1
    local result_var=$2
    local answer

    read -p "$prompt: " answer
    eval "$result_var"="$answer"
}

ask_hostname "What's the hostname" host_name

ask_yes_no "Is this a development environment?" is_dev
ask_yes_no "Is this a GUI environment?" is_gui

echo "HOSTNAME_ENV=${host_name}" > "$ENV_FILE"
echo "DEV_ENV=${is_dev}" >> "$ENV_FILE"
echo "GUI_ENV=${is_gui}" >> "$ENV_FILE"
