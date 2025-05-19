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
    *) os_name="otherlinux"; is_linux=true ;;
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

json_content=$(nix run nixpkgs#yj -- -t < "$toml_file")

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

. "${REPO_DIR}/scripts/common.sh"

setup_files="${REPO_DIR}/scripts/**/setup.sh"
for filepath in $setup_files; do
    # shellcheck disable=SC1090
    . "$filepath"
done
EOF


# pre functions
IFS=$'\n' read -r -d '' -a functions < <(echo "$json_content" | nix run nixpkgs#jq -- --arg os "$os_name" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select((.value["common"] != null or .value[$os] != null) and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | (.value["common"][]?, .value[$os][]?) | .function | select(. != null)' && printf '\0')

echo "# pre functions" >> "$install_script_path"
for func in "${functions[@]}"; do
    if type "pre_${func}" &> /dev/null; then
        {
            echo "title \"Pre-setup ${func#*_}\""
            echo "pre_${func}"
        } >> "$install_script_path"
    fi
done

# packages
echo "# package install/update commands" >> "$install_script_path"

# nix
nix_dir="${HOME}/.config/nix"

if [[ "$DISTRO" == "NixOS" ]] ||  [[ "$DISTRO" == "Darwin" ]] ; then
    printf '{ ... }:\n{}\n' > "${CONFIGS_DIR}/nix/systems/${os_name}/system_packages.nix"
fi
printf '{ ... }:\n{}\n' > "${CONFIGS_DIR}/nix/home-manager/system_packages.nix"

if [[ "$os_name" == "darwin" ]]; then
    nix_homebrew_apps_file="${CONFIGS_DIR}/nix/systems/darwin/homebrew-apps.nix"
    cp -rf "${CONFIGS_DIR}/nix/systems/darwin/homebrew-apps_template.nix" "$nix_homebrew_apps_file"

    echo "title \"Setup with nix-darwin\"" >> "$install_script_path"
    if ! (type darwin-rebuild > /dev/null 2>&1); then
        {
            echo "sudo mv /etc/shells{,.before-nix-darwin}"
            echo "sudo mv /etc/nix/nix.conf{,.before-nix-darwin}"
            echo "NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt nix --extra-experimental-features \"nix-command flakes\" run nix-darwin -- switch --flake ${nix_dir}#${HOSTNAME_ENV}"
        } >> "$install_script_path"
    else
        {
            echo "cd ${nix_dir} && nix flake update && cd -"
            echo "sudo darwin-rebuild switch --flake ${nix_dir}#${HOSTNAME_ENV}"
        } >> "$install_script_path"
    fi
elif [[ "$os_name" == "nixos" ]]; then
    {
        echo "title \"Setup nix\""
        echo "cd ${nix_dir} && nix --extra-experimental-features \"nix-command flakes\" flake update && cd -"
        echo "sudo nixos-rebuild switch --flake ${nix_dir}#${HOSTNAME_ENV}"
    } >> "$install_script_path"

else
    echo "title \"Install/Update packages from nix\"" >> "$install_script_path"
    if (type home-manager > /dev/null 2>&1); then
        {
            echo "nix flake update --flake ${nix_dir}"
            echo "home-manager switch --flake ${nix_dir}"
        } >> "$install_script_path"
    else
        echo "nix --extra-experimental-features \"nix-command flakes\" run home-manager/master -- switch --flake ${nix_dir}" >> "$install_script_path"
    fi
    echo "__ETC_PROFILE_NIX_SOURCED=\"\"" >> "$install_script_path"
fi

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

    if [ "$method" != "brew" ] &&  [ "$method" != "cask" ] && [ "$method" != "mas" ] && [ "$method" != "nix" ] && [ "$method" != "nix-hm" ]; then
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
    esac

    case "$method" in
        nix|nix-hm)
            if [[ "$method" == "nix" ]]; then
                if [[ "$DISTRO" == "NixOS" ]] ||  [[ "$DISTRO" == "Darwin" ]] ; then
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

            file_list=()
            package_list=()
            program_list=()

            while IFS= read -r -d '' file
            do
                file_list+=("$(basename "$file")")
            done < <(nix run nixpkgs#findutils -- "$programs_nix_dir" -type d -print0)

            for package in "${package_names[@]}"; do
                package_name=" $package "
                if [[ " ${file_list[*]} " =~ $package_name ]]; then
                    program_list+=("$package")
                else
                    package_list+=("$package")
                fi
            done
            packages=$(printf '    %s\n' "${package_list[@]}")

            packages=$([ ${#package_list[@]} -ne 0 ] && printf '    %s\n' "${package_list[@]}" || echo "")
            programs=$([ ${#program_list[@]} -ne 0 ] && printf '    ./programs/%s\n' "${program_list[@]}" || echo "")

            printf '{ config, pkgs, lib, ... }:\nlet\n  programModules = [\n%s\n  ];\nin\n{\n  imports = programModules;\n\n  %s = with pkgs; lib.concatLists ([[\n%s\n  ]] ++ (map (mod: mod.home.packages or []) programModules));\n}\n' \
                   "${programs}" \
                   "${package_prefix}" \
                   "${packages}" \
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
            if [ "$GITHUB_ACTIONS" == "y" ]; then
                mas_packages=""
            else
                mas_packages=$(printf '__n__      %s;' "${package_names[@]}")
            fi
            /usr/bin/sed -i "" "s|__MAS_PACKAGES__|$mas_packages|g" "$nix_homebrew_apps_file"
            /usr/bin/sed -i "" "s|__n__|\n|g" "$nix_homebrew_apps_file"
            ;;
        script)
            ;;
        *)
            echo "${install_cmd} ${package_names[*]}" >> "$install_script_path"
            ;;
    esac
done

if  [[ "$DISTRO" == "Darwin" ]] ; then
    /usr/bin/sed -i "" "s|__BREW_PACKAGES__||g" "$nix_homebrew_apps_file"
    /usr/bin/sed -i "" "s|__CASK_PACKAGES__||g" "$nix_homebrew_apps_file"
    /usr/bin/sed -i "" "s|__MAS_PACKAGES__||g" "$nix_homebrew_apps_file"
fi

# post functions
echo "# post functions" >> "$install_script_path"
for func in "${functions[@]}"; do
    if type "post_${func}" &> /dev/null; then
        {
            echo "title \"Post-setup ${func#*_}\""
            echo "post_${func}"
        } >> "$install_script_path"
    fi
done

echo "success \"Complete!\""  >> "$install_script_path"
