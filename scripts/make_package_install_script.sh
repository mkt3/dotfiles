#!/usr/bin/env bash

set -eu
set -o pipefail

# variable
CONFIGS_DIR="${REPO_DIR}/files"

# shellcheck source=/dev/null
. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${CONFIGS_DIR}/zsh/zshenv.zsh"

title "Making packages install script"

os_name=""

case "$DISTRO" in
    "Arch Linux") os_name="arch" ;;
    "Ubuntu") os_name="ubuntu" ;;
    "NixOS") os_name="nixos" ;;
    "Darwin") os_name="macos" ;;
    *) os_name="otherlinux" ;;
esac

dev_env=${DEV_ENV:-n}
gui_env=${GUI_ENV:-n}

declare -A methods
methods["ubuntu"]="apt"
methods["macos"]="brew cask mas"
methods["arch"]="pacman aur"
methods["nixos"]=""
methods["otherlinux"]=""
common_methods=("cargo" "nix" "nix-hm")

toml_file=${TOML_FILE:-"../toml_file"}
install_script_path=${INSTALL_SCRIPT:-"../results/install_packages.sh"}

json_content=$(yj -t < "$toml_file")

setup_files="${REPO_DIR:-..}/scripts/**/setup.sh"
for filepath in $setup_files; do
     # shellcheck disable=SC1090
    . "$filepath"
done


cat << 'EOF' > "$install_script_path"
#!/usr/bin/env bash
# shellcheck source=/dev/null

set -eu

# variable
CONFIGS_DIR="${REPO_DIR}/files"

. "${CONFIGS_DIR}/zsh/zshenv.zsh"

. "${REPO_DIR}/scripts/common.sh"

setup_files="${REPO_DIR}/scripts/**/setup.sh"
for filepath in $setup_files; do
    # shellcheck disable=SC1090
    . "$filepath"
done

EOF


# pre functions
IFS=$'\n' read -r -d '' -a functions < <(echo "$json_content" | jq --arg os "$os_name" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select((.value["common"] != null or .value[$os] != null) and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | (.value["common"][]?, .value[$os][]?) | .function | select(. != null)' && printf '\0')

echo "# pre functions" >> "$install_script_path"
for func in "${functions[@]}"; do
    if type "pre_${func}" &> /dev/null; then
        echo "title \"Pre-setup ${func#*_}\""  >> "$install_script_path"
        echo "pre_${func}" >> "$install_script_path"
    fi
done

# packages
echo "# package install/update commands" >> "$install_script_path"

# nix
nix_dir="${HOME}/.config/nix"
cp -rf "${CONFIGS_DIR}/nix" "$XDG_CONFIG_HOME"
if [[ "$os_name" == "macos" ]]; then
    nix_homebrew_apps_file="${CONFIGS_DIR}/nix/modules/darwin/homebrew-apps.nix"
    cp -rf "${CONFIGS_DIR}/nix/modules/darwin/homebrew-apps_template.nix" "$nix_homebrew_apps_file"

    echo "title \"Setup with nix-darwin\"" >> "$install_script_path"
    if ! (type darwin-rebuild > /dev/null 2>&1); then
        echo "nix run nix-darwin -- switch --flake ${nix_dir}" >> "$install_script_path"
    else
        echo "cd ${nix_dir} && nix flake update && cd -" >> "$install_script_path"
        echo "darwin-rebuild switch --flake ${nix_dir}" >> "$install_script_path"
    fi
elif [[ "$os_name" == "nixos" ]]; then
    echo "title \"Setup nix\"" >> "$install_script_path"
    echo "cd ${nix_dir} && nix flake update && cd -" >> "$install_script_path"
    echo "sudo nixos-rebuild switch --flake ${nix_dir}" >> "$install_script_path"
else
    echo "title \"Install/Update packages from nix\"" >> "$install_script_path"
    if (type home-manager > /dev/null 2>&1); then
        echo "nix flake update --flake ${nix_dir}" >> "$install_script_path"
        echo "home-manager switch --flake ${nix_dir}" >> "$install_script_path"
    else
        echo "nix run home-manager/master switch --flake ${nix_dir}" >> "$install_script_path"
    fi
fi

for method in ${methods[$os_name]} "${common_methods[@]}"; do
    IFS=$'\n' read -r -d '' -a package_names < <(echo "$json_content" | jq --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select((.value["common"] != null or .value[$os] != null) and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | (.value["common"][]?, .value[$os][]?) | select(.method == $method) | .name | select(. != null)' && printf '\0')

    if [ ${#package_names[@]} -eq 0 ]; then
        continue
    fi

    if [ "$method" != "brew" ] &&  [ "$method" != "cask" ] && [ "$method" != "mas" ] && [ "$method" != "nix" ] && [ "$method" != "nix-program" ]; then
        echo "title \"Install/Update packages from ${method}\""  >> "$install_script_path"
    fi
    install_cmd=""
    case "$method" in
        "apt")
            install_cmd="sudo apt-get -y install"
            ;;
        "pacman")
            install_cmd="sudo pacman -S --needed --noconfirm"
            ;;
        "aur")
            install_cmd="yay -S --needed --noconfirm"
            ;;
        "cargo")
            # shellcheck disable=SC2016
            install_cmd='"${CARGO_HOME}/bin/rustup" run stable cargo install'
            ;;
    esac

    case "$method" in
        nix|nix-hm)
            if [[ "$method" == "nix" ]]; then
                if [[ "$DISTRO" == "NixOS" ]]; then
                    packages_nix_path="${CONFIGS_DIR}/nix/modules/nixos/packages.nix"
                    package_prefix="environment.systemPackages"
                    module_nix_dir="${CONFIGS_DIR}/nix/modules/nixos/modules"
                else
                    packages_nix_path="${CONFIGS_DIR}/nix/home-manager/nix_system_packages.nix"
                    package_prefix="home.packages"
                    module_nix_dir="${CONFIGS_DIR}/nix/home-manager/modules"
                fi
            elif [[ "$method" == "nix-hm" ]]; then
                packages_nix_path="${CONFIGS_DIR}/nix/home-manager/packages.nix"
                package_prefix="home.packages"
                module_nix_dir="${CONFIGS_DIR}/nix/home-manager/modules"

                if [ ! -f "${CONFIGS_DIR}/nix/home-manager/nix_system_packages.nix" ]; then
                    printf '{ ... }:\n{}\n' > "${CONFIGS_DIR}/nix/home-manager/nix_system_packages.nix"
                fi
            fi

            package_list=()
            module_list=()

            while IFS= read -r -d '' file
            do
                file_list+=("$(basename -s .extension "$file")")
            done < <(find "$module_nix_dir" -type f -print0)

            for package in "${package_names[@]}"; do
                if [[ " ${file_list[*]} " =~ ${package} ]]; then
                    module_list+=("$package")
                else
                    package_list+=("$package")
                fi
            done
            packages=$(printf '    %s\n' "${package_list[@]}")

            packages=$([ ${#package_list[@]} -ne 0 ] && printf '    %s\n' "${package_list[@]}" || echo "")
            modules=$([ ${#module_list[@]} -ne 0 ] && printf '    ./modules/%s.nix\n' "${module_list[@]}" || echo "")

            printf '{ config, pkgs, ... }:\n{\n  %s = with pkgs; [\n%s\n  ];\n\n  imports = [\n%s\n  ];\n}\n' \
                   "${package_prefix}" \
                   "${packages}" \
                   "${modules}" \
                   > "$packages_nix_path"
            ;;
        brew)
            brew_packages=$(printf '__n__      "%s"' "${package_names[@]}")
            /usr/bin/sed -i "" "s|__BREW_PACKAGES__|$brew_packages|g" "$nix_homebrew_apps_file"
            /usr/bin/sed -i "" "s|__n__|\n|g" "$nix_homebrew_apps_file"
            ;;
        cask)
            cask_packages=$(printf '__n__      "%s"' "${package_names[@]}")
            /usr/bin/sed -i "" "s|__CASK_PACKAGES__|$cask_packages|g" "$nix_homebrew_apps_file"
            /usr/bin/sed -i "" "s|__n__|\n|g" "$nix_homebrew_apps_file"
            ;;
        mas)
            mas_packages=$(printf '__n__      %s;' "${package_names[@]}")
            /usr/bin/sed -i "" "s|__MAS_PACKAGES__|$mas_packages|g" "$nix_homebrew_apps_file"
            /usr/bin/sed -i "" "s|__n__|\n|g" "$nix_homebrew_apps_file"
            ;;
        cargo)
            for package in "${package_names[@]}"; do
                echo "${install_cmd} ${package}" >> "$install_script_path"
            done
            ;;
        script)
            ;;
        *)
            echo "${install_cmd} ${package_names[*]}" >> "$install_script_path"
            ;;
    esac
done

# post functions
echo "# post functions" >> "$install_script_path"
for func in "${functions[@]}"; do
    if type "post_${func}" &> /dev/null; then
        echo "title \"Post-setup ${func#*_}\""  >> "$install_script_path"
        echo "post_${func}" >> "$install_script_path"
    fi
done

echo "success \"Complete!\""  >> "$install_script_path"
