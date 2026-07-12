#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

DISTRO="${DISTRO_OVERRIDE:-$DISTRO}"

install_script_path=${INSTALL_SCRIPT:-"../results/install_packages.sh"}

os_name=""

detect_platform() {
    case "$DISTRO" in
        "Ubuntu") os_name="ubuntu" ;;
        "NixOS") os_name="nixos" ;;
        "Darwin") os_name="darwin" ;;
        *) os_name="${DISTRO,,}" ;;
    esac
}

write_install_script_header() {
    cat << 'EOF' > "$install_script_path"
#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

# variable
CONFIGS_DIR="${REPO_DIR}/nix"
NIX_DIR="${HOME}/.config/nix"

. "${REPO_DIR}/scripts/common.sh"
. "${REPO_DIR}/scripts/nix/setup.sh"

NIX_GITHUB_TOKEN_LOG=n setup_nix_github_token_from_gh

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

# pre function
title "Pre-setup nix"
pre_setup_nix
configure_ubuntu_nix_daemon_settings
EOF

    echo "# package install/update commands" >> "$install_script_path"
}

append_nix_switch_command() {
    local output=""

    if [[ "$os_name" == "darwin" ]]; then
        output+="title \"Setup with nix-darwin\"\n"
        output+="if ! command -v darwin-rebuild > /dev/null 2>&1; then\n"
        output+="    echo \"Setting up initial nix-darwin...\"\n"
        output+="    sudo mv /etc/shells{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    sudo mv /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt run_nixpkgs_nh darwin switch \${NIX_DIR} -H \${HOSTNAME_ENV}\n"
        output+="elif command -v nh > /dev/null 2>&1; then\n"
        output+="    run_nh darwin switch \${NIX_DIR} -H \${HOSTNAME_ENV}\n"
        output+="else\n"
        output+="    run_nixpkgs_nh darwin switch \${NIX_DIR} -H \${HOSTNAME_ENV}\n"
        output+="fi"
    elif [[ "$os_name" == "nixos" ]]; then
        output+="title \"Setup nixos\"\n"
        output+="if command -v nh > /dev/null 2>&1; then\n"
        output+="    run_nh os switch \${NIX_DIR} -H \${HOSTNAME_ENV}\n"
        output+="else\n"
        output+="    run_nixpkgs_nh os switch \${NIX_DIR} -H \${HOSTNAME_ENV}\n"
        output+="fi"
    else
        output+="title \"Install/Update packages from home-manager\"\n"
        output+="if command -v nh > /dev/null 2>&1; then\n"
        output+="    echo \"Switching home-manager with nh and current flake.lock...\"\n"
        output+="    run_nh home switch \${NIX_DIR} -c \${USER} --show-activation-logs\n"
        output+="else\n"
        output+="    echo \"Running nh via nix run with current flake.lock...\"\n"
        output+="    run_nixpkgs_nh home switch \${NIX_DIR} -c \${USER} --show-activation-logs\n"
        output+="fi\n"
        output+="export __ETC_PROFILE_NIX_SOURCED=\"\""
    fi

    echo -e "$output" >> "$install_script_path"
}

append_apt_package_command() {
    local package
    local package_output
    local packages=()

    if [ "$os_name" != "ubuntu" ]; then
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

    {
        echo 'title "Install/Update packages from apt"'
        printf 'sudo apt-get -y install'
        printf ' %q' "${packages[@]}"
        printf '\n'
    } >> "$install_script_path"
}

main() {
    title "Making packages install script"
    detect_platform
    write_install_script_header
    append_nix_switch_command
    append_apt_package_command
    echo 'success "Complete!"' >> "$install_script_path"
}

main
