#!/usr/bin/env bash

set -eu
set -o pipefail

# variable
CONFIGS_DIR="${REPO_DIR}/files"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"

GITHUB_ACTIONS=${GITHUB_ACTIONS:-n}

title "Making packages install script"

os_name=""
is_linux=false
case "$DISTRO" in
    "Arch Linux") os_name="arch"; is_linux=true ;;
    "Ubuntu") os_name="ubuntu"; is_linux=true ;;
    "NixOS") os_name="nixos"; is_linux=true ;;
    "Darwin") os_name="darwin" ;;
    *) os_name="${DISTRO,,}"; is_linux=true ;;
esac

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

SED_CMD="nix run nixpkgs#gnused -- -i "

info "Parsing TOML file to JSON..."
json_content=$(nix run nixpkgs#yj -- -t < "$toml_file")

cat << 'EOF' > "$install_script_path"
#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

# variable
CONFIGS_DIR="${REPO_DIR}/files"
NIX_DIR="${HOME}/.config/nix"

. "${REPO_DIR}/scripts/common.sh"
. "${REPO_DIR}/scripts/nix/setup.sh"

# pre function
title "Pre-setup nix"
pre_setup_nix
EOF

# packages
echo "# package install/update commands" >> "$install_script_path"

if [[ "$DISTRO" == "NixOS" ]] ||  [[ "$DISTRO" == "Darwin" ]] ; then
    printf '{ ... }:\n{}\n' > "${CONFIGS_DIR}/nix/systems/${os_name}/system_packages.nix"
fi
printf '{ ... }:\n{}\n' > "${CONFIGS_DIR}/nix/home-manager/system_packages.nix"

nix_homebrew_apps_file="${CONFIGS_DIR}/nix/systems/darwin/homebrew-apps.nix"

generate_nix_switch_command() {
    local os="$1"
    local output=""

    if [[ "$os" == "darwin" ]]; then
        cp -f "${CONFIGS_DIR}/nix/systems/darwin/homebrew-apps_template.nix" "$nix_homebrew_apps_file"
        output+="title \"Setup with nix-darwin\"\n"
        output+="cd \${NIX_DIR} && nix flake update && cd -\n"
        output+="if ! (type darwin-rebuild > /dev/null 2>&1); then\n"
        output+="    echo \"Setting up initial nix-darwin...\"\n"
        output+="    sudo mv /etc/shells{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    sudo mv /etc/nix/nix.conf{,.before-nix-darwin} 2>/dev/null || true\n"
        output+="    NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt nix --extra-experimental-features \"nix-command flakes\" run nix-darwin -- switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}\n"
        output+="else\n"
        output+="    sudo darwin-rebuild switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}\n"
        output+="fi"
    elif [[ "$os" == "nixos" ]]; then
        output+="title \"Setup nixos\"\n"
        output+="cd \${NIX_DIR} && nix --extra-experimental-features \"nix-command flakes\" flake update && cd -\n"
        output+="sudo nixos-rebuild switch --flake \${NIX_DIR}#\${HOSTNAME_ENV}"
    else
        output+="title \"Install/Update packages from home-manager\"\n"
        output+="if type home-manager > /dev/null 2>&1; then\n"
        output+="    echo \"Updating flakes and switching home-manager...\"\n"
        output+="    nix flake update --flake \${NIX_DIR}\n"
        output+="    home-manager switch --flake \${NIX_DIR}\n"
        output+="else\n"
        output+="    echo \"Running home-manager via nix run...\"\n"
        output+="    nix --extra-experimental-features \"nix-command flakes\" run home-manager/master -- switch --flake \${NIX_DIR}\n"
        output+="fi\n"
        output+="export __ETC_PROFILE_NIX_SOURCED=\"\""
    fi
    echo -e "$output" >> "$install_script_path"
}

generate_nix_switch_command "$os_name"

for method in ${methods[$os_name]} "${common_methods[@]}"; do
    IFS=$'\n' read -r -d '' -a package_names < <(echo "$json_content" | nix run nixpkgs#jq -- --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" --argjson is_linux "$is_linux" -r '
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

    if [ ${#package_names[@]} -eq 0 ]; then
        continue
    fi

    install_cmd=""
    case "$method" in
        "apt")
            echo "title \"Install/Update packages from apt\"" >> "$install_script_path"
            install_cmd="sudo apt-get -y install"
            ;;
        "pacman")
            echo "title \"Install/Update packages from pacman\"" >> "$install_script_path"
            install_cmd="sudo pacman -S --needed --noconfirm"
            ;;
        "aur")
            echo "title \"Install/Update packages from aur\"" >> "$install_script_path"
            install_cmd="yay -S --needed --noconfirm"
            ;;
    esac

    case "$method" in
        nix|nix-hm)
            programs_nix_dir=""
            packages_nix_path=""
            package_prefix=""
            if [[ "$method" == "nix" ]]; then
                if [[ "$DISTRO" == "NixOS" ]] || [[ "$DISTRO" == "Darwin" ]] ; then
                    packages_nix_path="${CONFIGS_DIR}/nix/systems/${os_name}/system_packages.nix"
                    package_prefix="environment.systemPackages"
                    programs_nix_dir="${CONFIGS_DIR}/nix/systems/${os_name}/programs"
                else
                    packages_nix_path="${CONFIGS_DIR}/nix/home-manager/system_packages.nix"
                    package_prefix="home.packages"
                    programs_nix_dir="${CONFIGS_DIR}/nix/home-manager/programs"
                fi
            elif [[ "$method" == "nix-hm" ]]; then
                packages_nix_path="${CONFIGS_DIR}/nix/home-manager/packages.nix"
                package_prefix="home.packages"
                programs_nix_dir="${CONFIGS_DIR}/nix/home-manager/programs"
            fi
            mkdir -p "$programs_nix_dir"

            package_list=()
            program_list=()

            for package in "${package_names[@]}"; do
                if [ -d "$programs_nix_dir/$package" ]; then
                    program_list+=("$package")
                else
                    package_list+=("$package")
                fi
            done

            packages=$([ ${#package_list[@]} -ne 0 ] && printf '    %s\n' "${package_list[@]}" || echo "")
            programs=$([ ${#program_list[@]} -ne 0 ] && printf '    ./programs/%s\n' "${program_list[@]}" || echo "")

            printf '{ config, pkgs, lib, ... }:\nlet\n  programModules = [\n%s\n  ];\nin\n{\n  imports = programModules;\n\n  %s = with pkgs; lib.concatLists ([[\n%s\n  ]] ++ (map (mod: mod.home.packages or []) programModules));\n}\n' \
                   "${programs}" \
                   "${package_prefix}" \
                   "${packages}" \
                   > "$packages_nix_path"
            ;;
        brew|cask|mas)
            placeholder=""
            packages_string=""
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
                    if [ "$GITHUB_ACTIONS" == "y" ]; then
                        packages_string=""
                    else
                        packages_string=$(printf '__n__      %s;' "${package_names[@]}")
                    fi
                    ;;
            esac

            ${SED_CMD} "s|${placeholder}|${packages_string}|g" "$nix_homebrew_apps_file"
            ${SED_CMD} "s|__n__|\n|g" "$nix_homebrew_apps_file"
            ;;
        script)
            ;;
        *)
            if [ -n "$install_cmd" ]; then
                echo "${install_cmd} ${package_names[*]}" >> "$install_script_path"
            fi
            ;;
    esac
done

if [[ "$DISTRO" == "Darwin" ]] ; then
    ${SED_CMD} "s|__BREW_PACKAGES__||g; \
                s|__CASK_PACKAGES__||g; \
                s|__MAS_PACKAGES__||g" "$nix_homebrew_apps_file"
fi

echo "success \"Complete!\""  >> "$install_script_path"
