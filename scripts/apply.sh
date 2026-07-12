#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="${REPO_DIR:-$(CDPATH='' cd -- "${script_dir}/.." && pwd)}"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/nix/setup.sh"

export CONFIGS_DIR="${REPO_DIR}/nix"
NIX_DIR="${XDG_CONFIG_HOME}/nix"

run_nh() {
    env \
        "NH_FLAKE=${NIX_DIR}" \
        "NH_OS_FLAKE=${NIX_DIR}" \
        "NH_HOME_FLAKE=${NIX_DIR}" \
        "NH_DARWIN_FLAKE=${NIX_DIR}" \
        nh "$@"
}

run_nixpkgs_nh() {
    env \
        "NH_FLAKE=${NIX_DIR}" \
        "NH_OS_FLAKE=${NIX_DIR}" \
        "NH_HOME_FLAKE=${NIX_DIR}" \
        "NH_DARWIN_FLAKE=${NIX_DIR}" \
        "${NIX_CMD[@]}" run nixpkgs#nh -- "$@"
}

install_apt_packages() {
    local package
    local package_output
    local packages=()

    if [ "$DISTRO" != "Ubuntu" ]; then
        return 0
    fi

    package_output=$(env \
        APT_PACKAGES_NIX="${REPO_DIR}/nix/apt-packages.nix" \
        DEV_ENV="${DEV_ENV:-n}" \
        GUI_ENV="${GUI_ENV:-n}" \
        "${NIX_CMD[@]}" eval --impure --raw --expr '
          import (builtins.getEnv "APT_PACKAGES_NIX") {
            isDev = builtins.getEnv "DEV_ENV" == "y";
            isGUI = builtins.getEnv "GUI_ENV" == "y";
          }
        ')

    while IFS= read -r package; do
        if [ -n "$package" ]; then
            packages+=("$package")
        fi
    done <<< "$package_output"

    if [ ${#packages[@]} -eq 0 ]; then
        return 0
    fi

    title "Install/Update packages from apt"
    sudo apt-get -y install "${packages[@]}"
}

apply_configuration() {
    case "$DISTRO" in
        Darwin)
            title "Setup with nix-darwin"
            if ! command -v darwin-rebuild >/dev/null 2>&1; then
                echo "Setting up initial nix-darwin..."
                sudo mv /etc/shells{,.before-nix-darwin} 2>/dev/null || true
                sudo mv /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true
                NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt \
                    run_nixpkgs_nh darwin switch "$NIX_DIR" -H "$HOSTNAME_ENV"
            elif command -v nh >/dev/null 2>&1; then
                run_nh darwin switch "$NIX_DIR" -H "$HOSTNAME_ENV"
            else
                run_nixpkgs_nh darwin switch "$NIX_DIR" -H "$HOSTNAME_ENV"
            fi
            ;;
        NixOS)
            title "Setup NixOS"
            if command -v nh >/dev/null 2>&1; then
                run_nh os switch "$NIX_DIR" -H "$HOSTNAME_ENV"
            else
                run_nixpkgs_nh os switch "$NIX_DIR" -H "$HOSTNAME_ENV"
            fi
            ;;
        *)
            title "Install/Update packages from Home Manager"
            if command -v nh >/dev/null 2>&1; then
                run_nh home switch "$NIX_DIR" -c "$USER" --show-activation-logs
            else
                run_nixpkgs_nh home switch "$NIX_DIR" -c "$USER" --show-activation-logs
            fi
            export __ETC_PROFILE_NIX_SOURCED=""
            ;;
    esac
}

title "Prepare Nix configuration"
NIX_GITHUB_TOKEN_LOG=n setup_nix_github_token_from_gh
pre_setup_nix
configure_ubuntu_nix_daemon_settings
install_apt_packages
apply_configuration
success "Complete!"
