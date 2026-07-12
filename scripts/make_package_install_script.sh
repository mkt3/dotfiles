#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

dev_env=${DEV_ENV:-n}
gui_env=${GUI_ENV:-n}

declare -A methods
methods["ubuntu"]="apt"
methods["darwin"]=""
methods["nixos"]=""
methods["otherlinux"]=""

toml_file=${TOML_FILE:-"../toml_file"}
install_script_path=${INSTALL_SCRIPT:-"../results/install_packages.sh"}

os_name=""
is_linux=false
json_content=""

detect_platform() {
    case "$DISTRO" in
        "Ubuntu") os_name="ubuntu"; is_linux=true ;;
        "NixOS") os_name="nixos"; is_linux=true ;;
        "Darwin") os_name="darwin" ;;
        *) os_name="${DISTRO,,}"; is_linux=true ;;
    esac
}

parse_package_catalog() {
    info "Parsing TOML file to JSON..."
    json_content=$("${NIX_CMD[@]}" run nixpkgs#yj -- -t < "$toml_file")
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

remove_generated_nix_tree() {
    rm -rf "${REPO_DIR}/results/generated/nix"
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

get_package_names_for_method() {
    local method="$1"

    # shellcheck disable=SC2016
    IFS=$'\n' read -r -d '' -a package_names < <(echo "$json_content" | "${NIX_CMD[@]}" run nixpkgs#jq -- --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" --argjson is_linux "$is_linux" -r '
      to_entries | .[] |
      select(
        (.value.common != null or ($is_linux and .value.linux != null) or .value[$os] != null) and
        (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))
      ) |
        if $os != "darwin" then
          (.value.common[]?, .value.linux[]?, .value[$os][]?)
        else
          (.value.common[]?, .value[$os][]?)
        end |
      select(.method == $method) |
      .name |
      select(. != null)' && printf '\0')
}

append_native_package_command() {
    local method="$1"
    local install_cmd=""

    case "$method" in
        apt)
            echo "title \"Install/Update packages from apt\"" >> "$install_script_path"
            install_cmd="sudo apt-get -y install"
            ;;
    esac

    if [ -n "$install_cmd" ]; then
        echo "${install_cmd} ${package_names[*]}" >> "$install_script_path"
    fi
}

process_method() {
    local method="$1"
    local package_names=()

    get_package_names_for_method "$method"
    if [ ${#package_names[@]} -eq 0 ]; then
        return 0
    fi

    case "$method" in
        script)
            ;;
        *)
            append_native_package_command "$method"
            ;;
    esac
}

main() {
    local method
    local platform_methods

    title "Making packages install script"
    detect_platform
    write_install_script_header
    remove_generated_nix_tree
    append_nix_switch_command

    platform_methods="${methods[$os_name]}"
    if [ -n "$platform_methods" ]; then
        parse_package_catalog
    fi
    for method in $platform_methods; do
        process_method "$method"
    done

    echo 'success "Complete!"' >> "$install_script_path"
}

main
