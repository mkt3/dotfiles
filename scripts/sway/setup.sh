#!/usr/bin/env bash

set -eu

setup_sway() {
    title "Setting up sway"
    local sway_file_dir="${CONFIGS_DIR}/sway"
    local swaylock_file_dir="${CONFIGS_DIR}/swaylock"
    local waybar_file_dir="${CONFIGS_DIR}/waybar"
    local rofi_file_dir="${CONFIGS_DIR}/rofi"
    local kanshi_file_dir="${CONFIGS_DIR}/kanshi"

    info "Creating symlink for sway"
    ln -sfn "${sway_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for swaylock"
    ln -sfn "${swaylock_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for waybar"
    ln -sfn "${waybar_file_dir}" "${XDG_CONFIG_HOME}"

    info "Creating symlink for rofi"
    ln -sfn "${rofi_file_dir}" "${XDG_CONFIG_HOME}"

    info "Adding sway-session.target"
    mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
    ln -sfn "${sway_file_dir}/sway-session.target" "${XDG_CONFIG_HOME}/systemd/user/"

    info "Adding kanshi"
    ln -sfn "${kanshi_file_dir}" "${XDG_CONFIG_HOME}"
    ln -sfn "${kanshi_file_dir}/kanshi.service" "${XDG_CONFIG_HOME}/systemd/user/"

}
