#!/usr/bin/env bash

set -eu

setup_sway() {
    title "Setting up sway"
    local sway_file_dir="${CONFIGS_DIR}/sway"
    local swaylock_file_dir="${CONFIGS_DIR}/swaylock"
    local waybar_file_dir="${CONFIGS_DIR}/waybar"
    local rofi_file_dir="${CONFIGS_DIR}/rofi"

    info "Creating symlink for sway"
    ln -sfn "${sway_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for swaylock"
    ln -sfn "${swaylock_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for waybar"
    ln -sfn "${waybar_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for rofi"
    ln -sfn "${rofi_file_dir}" "${XDG_CONFIG_HOME}"

}
