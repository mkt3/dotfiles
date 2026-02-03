#!/usr/bin/env bash

set -euo pipefail

if ! declare -p NIX_CMD >/dev/null 2>&1; then
    NIX_CMD=(nix --extra-experimental-features "nix-command flakes")
fi

pre_setup_nix() {
    info "Creating symlink for nix"

    local nix_config_dir="${CONFIGS_DIR}/nix"
    local nix_main_flake_dir="${XDG_CONFIG_HOME}/nix"
    local nix_main_template_flake="${nix_main_flake_dir}/flake_template.nix"
    local nix_main_flake="${nix_main_flake_dir}/flake.nix"
    local host_name="$HOSTNAME_ENV"
    local nix_platform
    local is_gui

    # run_nvfetcher_if_needed

    nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')
    # for macos
    nix_platform=${nix_platform/arm64-darwin/aarch64-darwin}

    is_gui=$([ "$GUI_ENV" = "y" ] && echo "true" || echo "false")

    if [ -f "${XDG_CONFIG_HOME}/nix/flake.lock" ]; then
        cp -f "${XDG_CONFIG_HOME}/nix/flake.lock" "$nix_config_dir"
    fi

    rm -rf -- "${XDG_CONFIG_HOME}/nix"
    cp -rf "$nix_config_dir" "$XDG_CONFIG_HOME"

    mv "$nix_main_template_flake" "$nix_main_flake"
    if [ "$DISTRO" = "NixOS" ]; then
        local nixos_systems_dir="${nix_main_flake_dir}/systems/nixos"
        if [ -d "$nixos_systems_dir" ]; then
            cp -f "/etc/nixos/hardware-configuration.nix" "$nixos_systems_dir"
        else
            warning "Warning: NixOS systems directory not found at $nixos_systems_dir. Skipping hardware config copy."
        fi
    fi

    "${NIX_CMD[@]}" run nixpkgs#gnused -- -i \
        -e "s|__SYSTEM__|${nix_platform}|g" \
        -e "s|__HOSTNAME__|${host_name}|g" \
        -e "s|__USERNAME__|${USER}|g" \
        -e "s|__HOMEDIRECTORY__|${HOME}|g" \
        -e "s|\"__ISGUI__\"|${is_gui}|g" \
        "$nix_main_flake"

    info "Finished pre-setup for nix"
}

run_nvfetcher_if_needed() {
    local nvfetcher_last_run_file="${REPO_DIR}/results/nvfetcher_last_run"
    local one_day_in_seconds=86400
    local should_run_nvfetcher="true"

    mkdir -p "${REPO_DIR}/results"

    if [ -f "$nvfetcher_last_run_file" ]; then
        local last_run_timestamp
        last_run_timestamp=$(cat "$nvfetcher_last_run_file" 2>/dev/null || echo 0)

        local current_timestamp
        current_timestamp=$(date +%s)

        local time_diff=$((current_timestamp - last_run_timestamp))

        if [ "$time_diff" -lt "$one_day_in_seconds" ]; then
            info "nvfetcher skipped. Last run was within the last $((time_diff / 3600)) hours."
            should_run_nvfetcher="false"
        fi
    fi

    if [ "$should_run_nvfetcher" != "true" ]; then
        return 0
    fi

    info "Updating nix packages with nvfetcher (more than 24 hours elapsed or first run)"

    local nvfetcher_command
    if command -v nvfetcher > /dev/null 2>&1; then
        nvfetcher_command=(nvfetcher)
    else
        nvfetcher_command=("${NIX_CMD[@]}" run github:berberman/nvfetcher --)
    fi

    if "${nvfetcher_command[@]}" \
        -c "${REPO_DIR}/files/nix/nvfetcher.toml" \
        -o "${REPO_DIR}/files/nix/_sources"; then
        date +%s > "$nvfetcher_last_run_file"
        info "nvfetcher execution successful. Timestamp updated."
    else
        warning "nvfetcher failed. Continuing setup with existing sources."
    fi
}
