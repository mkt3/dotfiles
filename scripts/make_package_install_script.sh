#!/usr/bin/env bash

set -euo pipefail

# variable
CONFIGS_DIR="${REPO_DIR}/nix"
GENERATED_CONFIGS_DIR="${REPO_DIR}/results/generated"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

GITHUB_ACTIONS=${GITHUB_ACTIONS:-n}

dev_env=${DEV_ENV:-n}
gui_env=${GUI_ENV:-n}

declare -A methods
methods["ubuntu"]="apt"
methods["darwin"]="brew cask mas"
methods["arch"]="pacman aur"
methods["nixos"]=""
methods["otherlinux"]=""
common_methods=("nix" "nix-hm")

toml_file=${TOML_FILE:-"../toml_file"}
install_script_path=${INSTALL_SCRIPT:-"../results/install_packages.sh"}

SED_CMD=("${NIX_CMD[@]}" run nixpkgs#gnused -- -i)
nix_homebrew_apps_file="${GENERATED_CONFIGS_DIR}/nix/systems/darwin/homebrew-apps.nix"
os_name=""
is_linux=false
json_content=""

detect_platform() {
    case "$DISTRO" in
        "Arch Linux") os_name="arch"; is_linux=true ;;
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

# pre function
title "Pre-setup nix"
pre_setup_nix
EOF

    echo "# package install/update commands" >> "$install_script_path"
}

initialize_generated_nix_tree() {
    rm -rf "${GENERATED_CONFIGS_DIR}/nix"
    mkdir -p "${GENERATED_CONFIGS_DIR}/nix/home-manager" "${GENERATED_CONFIGS_DIR}/nix/systems/darwin" "${GENERATED_CONFIGS_DIR}/nix/systems/nixos"

    if [[ "$DISTRO" == "NixOS" ]] || [[ "$DISTRO" == "Darwin" ]]; then
        printf '{ ... }:\n{}\n' > "${GENERATED_CONFIGS_DIR}/nix/systems/${os_name}/system_packages.nix"
    fi
    printf '{ ... }:\n{}\n' > "${GENERATED_CONFIGS_DIR}/nix/home-manager/system_packages.nix"
}

append_nix_switch_command() {
    local output=""

    if [[ "$os_name" == "darwin" ]]; then
        cp -f "${CONFIGS_DIR}/systems/darwin/homebrew-apps_template.nix" "$nix_homebrew_apps_file"
        output+="title \"Setup with nix-darwin\"\n"
        output+="if ! command -v darwin-rebuild > /dev/null 2>&1; then\n"
        output+="    echo \"Setting up initial nix-darwin...\"\n"
        output+="    sudo mv /etc/shells{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    sudo mv /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt sudo \"\${NIX_CMD[@]}\" run nix-darwin -- switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}\n"
        output+="else\n"
        output+="    sudo darwin-rebuild switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}\n"
        output+="fi"
    elif [[ "$os_name" == "nixos" ]]; then
        output+="title \"Setup nixos\"\n"
        output+="sudo nixos-rebuild switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}"
    else
        output+="title \"Install/Update packages from home-manager\"\n"
        output+="if command -v home-manager > /dev/null 2>&1; then\n"
        output+="    echo \"Switching home-manager with current flake.lock...\"\n"
        output+="    home-manager switch --flake \${NIX_DIR}\n"
        output+="else\n"
        output+="    echo \"Running home-manager via nix run...\"\n"
        output+="    \"\${NIX_CMD[@]}\" run home-manager/master -- init --switch --flake \${NIX_DIR}\n"
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
        pacman)
            echo "title \"Install/Update packages from pacman\"" >> "$install_script_path"
            install_cmd="sudo pacman -S --needed --noconfirm"
            ;;
        aur)
            echo "title \"Install/Update packages from aur\"" >> "$install_script_path"
            install_cmd="yay -S --needed --noconfirm"
            ;;
    esac

    if [ -n "$install_cmd" ]; then
        echo "${install_cmd} ${package_names[*]}" >> "$install_script_path"
    fi
}

resolve_nix_targets() {
    local method="$1"

    programs_nix_dir=""
    packages_nix_path=""
    package_prefix=""

    if [[ "$method" == "nix" ]]; then
        if [[ "$DISTRO" == "NixOS" ]] || [[ "$DISTRO" == "Darwin" ]]; then
            packages_nix_path="${GENERATED_CONFIGS_DIR}/nix/systems/${os_name}/system_packages.nix"
            package_prefix="environment.systemPackages"
            programs_nix_dir="${CONFIGS_DIR}/systems/${os_name}/programs"
        else
            packages_nix_path="${GENERATED_CONFIGS_DIR}/nix/home-manager/system_packages.nix"
            package_prefix="home.packages"
            programs_nix_dir="${CONFIGS_DIR}/home-manager/programs"
        fi
    else
        packages_nix_path="${GENERATED_CONFIGS_DIR}/nix/home-manager/packages.nix"
        package_prefix="home.packages"
        programs_nix_dir="${CONFIGS_DIR}/home-manager/programs"
    fi
}

write_nix_package_module() {
    local method="$1"
    local package
    local package_list=()
    local program_list=()
    local packages=""
    local programs=""

    resolve_nix_targets "$method"
    mkdir -p "$programs_nix_dir"

    for package in "${package_names[@]}"; do
        if [ -d "$programs_nix_dir/$package" ]; then
            program_list+=("$package")
        else
            package_list+=("$package")
        fi
    done

    packages=$([ ${#package_list[@]} -ne 0 ] && printf '    %s\n' "${package_list[@]}" || echo "")
    programs=$([ ${#program_list[@]} -ne 0 ] && printf '    ./programs/%s\n' "${program_list[@]}" || echo "")

    cat <<EOF > "$packages_nix_path"
{ pkgs, ... }:
let
  programModules = [
${programs}
  ];
in
{
  imports = programModules;

  ${package_prefix} = with pkgs; [
${packages}
  ];
}
EOF
}

apply_homebrew_packages() {
    local method="$1"
    local placeholder=""
    local packages_string=""

    case "$method" in
        brew)
            placeholder="__BREW_PACKAGES__"
            packages_string=$(printf '__n__      "%s"' "${package_names[@]}")
            ;;
        cask)
            placeholder="__CASK_PACKAGES__"
            packages_string=$(printf '__n__      "%s"' "${package_names[@]}")
            ;;
        mas)
            placeholder="__MAS_PACKAGES__"
            if [ "$GITHUB_ACTIONS" != "y" ]; then
                packages_string=$(printf '__n__      %s;' "${package_names[@]}")
            fi
            ;;
    esac

    "${SED_CMD[@]}" "s|${placeholder}|${packages_string}|g" "$nix_homebrew_apps_file"
    "${SED_CMD[@]}" "s|__n__|\n|g" "$nix_homebrew_apps_file"
}

process_method() {
    local method="$1"
    local package_names=()

    get_package_names_for_method "$method"
    if [ ${#package_names[@]} -eq 0 ]; then
        return 0
    fi

    case "$method" in
        nix|nix-hm)
            write_nix_package_module "$method"
            ;;
        brew|cask|mas)
            apply_homebrew_packages "$method"
            ;;
        script)
            ;;
        *)
            append_native_package_command "$method"
            ;;
    esac
}

finalize_homebrew_template() {
    if [[ "$DISTRO" == "Darwin" ]]; then
        "${SED_CMD[@]}" "s|__BREW_PACKAGES__||g; \
                    s|__CASK_PACKAGES__||g; \
                    s|__MAS_PACKAGES__||g" "$nix_homebrew_apps_file"
    fi
}

main() {
    local method

    title "Making packages install script"
    detect_platform
    parse_package_catalog
    write_install_script_header
    initialize_generated_nix_tree
    append_nix_switch_command

    for method in ${methods[$os_name]} "${common_methods[@]}"; do
        process_method "$method"
    done

    finalize_homebrew_template
    echo 'success "Complete!"' >> "$install_script_path"
}

main
