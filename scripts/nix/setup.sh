#!/usr/bin/env bash

set -euo pipefail

if ! declare -p NIX_CMD >/dev/null 2>&1; then
    NIX_CMD=(nix)
fi

log_nix_github_token_status() {
    if [ "${NIX_GITHUB_TOKEN_LOG:-y}" = "y" ]; then
        info "$1"
    fi
}

setup_nix_github_token_from_gh() {
    if [ "${GUI_ENV:-n}" != "y" ]; then
        log_nix_github_token_status "Skipping GitHub token setup for Nix because GUI_ENV is not enabled."
        return 0
    fi

    if ! command -v gh > /dev/null 2>&1; then
        log_nix_github_token_status "Skipping GitHub token setup for Nix because gh is not installed."
        return 0
    fi

    local github_token=""
    github_token=$(gh auth token 2>/dev/null || true)
    if [ -z "$github_token" ]; then
        log_nix_github_token_status "Skipping GitHub token setup for Nix because gh auth token is unavailable."
        return 0
    fi

    case "${NIX_CONFIG:-}" in
        *"github.com="*)
            log_nix_github_token_status "GitHub token for Nix is already configured in NIX_CONFIG."
            return 0
            ;;
    esac

    export NIX_CONFIG="${NIX_CONFIG:+${NIX_CONFIG}
}access-tokens = github.com=${github_token}"
    log_nix_github_token_status "Configured GitHub token for Nix from gh auth token."
}

upsert_nix_conf_token() {
    local key="$1"
    local token="$2"
    local file="$3"
    local next_file=""
    next_file=$(mktemp)

    awk -v key="$key" -v token="$token" '
        BEGIN { seen = 0 }
        /^[[:space:]]*#/ { print; next }
        $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
            seen = 1
            line = $0
            value = substr($0, index($0, "=") + 1)
            if (index(" " value " ", " " token " ") == 0) {
                line = line " " token
            }
            print line
            next
        }
        { print }
        END {
            if (!seen) {
                print key " = " token
            }
        }
    ' "$file" > "$next_file"
    mv "$next_file" "$file"
}

configure_ubuntu_nix_daemon_settings() {
    if [ "${DISTRO:-}" != "Ubuntu" ]; then
        return 0
    fi

    if ! command -v sudo >/dev/null 2>&1; then
        warning "Skipping Nix daemon trusted-users setup because sudo is unavailable."
        return 0
    fi

    local nix_conf="/etc/nix/nix.custom.conf"
    local tmp_file=""
    tmp_file=$(mktemp)

    sudo mkdir -p "$(dirname "$nix_conf")"
    sudo touch "$nix_conf"
    sudo cat "$nix_conf" | tee "$tmp_file" >/dev/null

    upsert_nix_conf_token "trusted-users" "root" "$tmp_file"
    upsert_nix_conf_token "trusted-users" "$USER" "$tmp_file"

    if sudo cmp -s "$tmp_file" "$nix_conf"; then
        info "Nix daemon trusted-users is already configured for Ubuntu."
        rm -f "$tmp_file"
        return 0
    fi

    sudo install -m 0644 "$tmp_file" "$nix_conf"
    rm -f "$tmp_file"
    info "Updated $nix_conf to trust the current user."

    if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files nix-daemon.service >/dev/null 2>&1; then
        sudo systemctl restart nix-daemon.service || warning "Failed to restart nix-daemon.service. Restart it manually before running Nix commands with flake nixConfig."
    else
        warning "Restart the Nix daemon before running Nix commands with flake nixConfig."
    fi
}

detect_nix_platform() {
    local nix_platform

    if [ -n "${NIX_PLATFORM_OVERRIDE:-}" ]; then
        echo "$NIX_PLATFORM_OVERRIDE"
        return 0
    fi

    nix_platform=$(echo "$(uname -m)-$(uname -s)" | tr '[:upper:]' '[:lower:]')
    echo "${nix_platform/arm64-darwin/aarch64-darwin}"
}

sync_flake_sources() {
    local nix_config_dir="$1"
    local nix_main_flake_dir="$2"
    local source_path=""
    local source_name=""

    mkdir -p "$nix_main_flake_dir"

    shopt -s dotglob nullglob
    for source_path in "${nix_config_dir}"/*; do
        source_name="$(basename "$source_path")"
        case "$source_name" in
            nix.conf) continue ;;
        esac

        rm -rf "${nix_main_flake_dir:?}/${source_name}"
        cp -Rf "$source_path" "$nix_main_flake_dir/"
    done
    shopt -u dotglob nullglob

    rm -f "${nix_main_flake_dir}/flake_template.nix"
    cp -f "${REPO_DIR}/packages.toml" "$nix_main_flake_dir/packages.toml"
}

sync_flake_lock_to_repo() {
    local source_lock="$1"

    if [ ! -f "$source_lock" ]; then
        echo "flake.lock was not generated: $source_lock" >&2
        return 1
    fi

    cp -f "$source_lock" "${REPO_DIR}/nix/flake.lock"
}

copy_nixos_hardware_config() {
    local nix_main_flake_dir="$1"
    local nixos_systems_dir="${nix_main_flake_dir}/systems/nixos"
    local hardware_config="${NIXOS_HARDWARE_CONFIG_OVERRIDE:-/etc/nixos/hardware-configuration.nix}"

    if [ "$DISTRO" != "NixOS" ]; then
        return 0
    fi

    if [ -d "$nixos_systems_dir" ]; then
        if [ ! -f "$hardware_config" ]; then
            error "NixOS hardware configuration not found: $hardware_config"
        fi
        cp -f "$hardware_config" "$nixos_systems_dir/hardware-configuration.nix"
    else
        warning "Warning: NixOS systems directory not found at $nixos_systems_dir. Skipping hardware config copy."
    fi
}

write_host_json() {
    local host_json="$1"
    local nix_platform="$2"
    local os_name="$3"
    local host_name="$4"
    local is_gui="$5"
    local is_dev="$6"
    local tmp_file=""

    tmp_file=$(mktemp "${host_json}.tmp.XXXXXX")
    if env \
        HOST_CONFIG_PLATFORM="$nix_platform" \
        HOST_CONFIG_OS="$os_name" \
        HOST_CONFIG_HOSTNAME="$host_name" \
        HOST_CONFIG_USERNAME="$USER" \
        HOST_CONFIG_HOME="$HOME" \
        HOST_CONFIG_IS_GUI="$is_gui" \
        HOST_CONFIG_IS_DEV="$is_dev" \
        "${NIX_CMD[@]}" eval --impure --json --expr '
          {
            platform = builtins.getEnv "HOST_CONFIG_PLATFORM";
            os = builtins.getEnv "HOST_CONFIG_OS";
            hostname = builtins.getEnv "HOST_CONFIG_HOSTNAME";
            username = builtins.getEnv "HOST_CONFIG_USERNAME";
            homeDirectory = builtins.getEnv "HOST_CONFIG_HOME";
            isGUI = builtins.getEnv "HOST_CONFIG_IS_GUI" == "true";
            isDev = builtins.getEnv "HOST_CONFIG_IS_DEV" == "true";
          }
        ' > "$tmp_file"; then
        chmod 600 "$tmp_file"
        mv -f "$tmp_file" "$host_json"
    else
        rm -f "$tmp_file"
        return 1
    fi
}

pre_setup_nix() {
    info "Preparing Nix configuration"

    local nix_config_dir="${CONFIGS_DIR}"
    local nix_main_flake_dir="${XDG_CONFIG_HOME}/nix"
    local nix_source_flake="${nix_main_flake_dir}/flake.source.nix"
    local nix_main_flake="${nix_main_flake_dir}/flake.nix"
    local host_json="${nix_main_flake_dir}/host.json"
    local host_name="$HOSTNAME_ENV"
    local nix_platform=""
    local os_name=""
    local is_gui=""
    local is_dev=""

    nix_platform=$(detect_nix_platform)
    case "$DISTRO" in
        Darwin) os_name="darwin" ;;
        NixOS) os_name="nixos" ;;
        *) os_name="ubuntu" ;;
    esac
    is_gui=$([ "$GUI_ENV" = "y" ] && echo "true" || echo "false")
    is_dev=$([ "$DEV_ENV" = "y" ] && echo "true" || echo "false")

    sync_flake_sources "$nix_config_dir" "$nix_main_flake_dir"
    cp -f "$nix_source_flake" "$nix_main_flake"
    rm -f "$nix_source_flake"
    copy_nixos_hardware_config "$nix_main_flake_dir"
    write_host_json "$host_json" "$nix_platform" "$os_name" "$host_name" "$is_gui" "$is_dev"

    info "Finished pre-setup for nix"
}
