#!/usr/bin/env bash

set -eu
set -o pipefail

# variable
CONFIGS_DIR="${REPO_DIR}/files"

. "${REPO_DIR}/scripts/common.sh"
# shellcheck source=/dev/null
. "${CONFIGS_DIR}/zsh/zshenv.zsh"

title "Making packages install script"

os_name=""

case "$DISTRO" in
    "Arch") os_name="arch" ;;
    "Ubuntu") os_name="ubuntu" ;;
    "Darwin") os_name="macos" ;;
    *) echo "${os_name} is not supported."; exit 1 ;;
esac

dev_env=${DEV_ENV:-n}
gui_env=${GUI_ENV:-n}

declare -A methods
methods["ubuntu"]="apt"
methods["macos"]="brew cask mas"
methods["arch"]="pacman aur"
common_methods=("cargo" "nix")

toml_file=${TOML_FILE:-"../toml_file"}
install_script_path=${INSTALL_SCRIPT:-"../results/install_packages.sh"}

brew_file="${REPO_DIR:-..}/results/Brewfile"
home_manager_dir="${HOME}/.config/home-manager"

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

if ! (type home-manager > /dev/null 2>&1); then
    echo "title \"Install packages from nix\"" >> "$install_script_path"
    echo "nix run home-manager/master -- init --switch" >> "$install_script_path"
else
    echo "title \"Update packages from nix\"" >> "$install_script_path"
    echo "nix flake update --flake ${home_manager_dir}" >> "$install_script_path"
    echo "home-manager switch" >> "$install_script_path"
fi

if [[ "$os_name" == "macos" ]]; then
    echo -n > "$brew_file"

    {
        echo "title \"Install/Update packages from homebrew\""
        echo "brew bundle --file $brew_file"
        echo "brew upgrade"
        echo "brew cleanup"
    } >> "$install_script_path"
fi

for method in ${methods[$os_name]} "${common_methods[@]}"; do
    IFS=$'\n' read -r -d '' -a package_names < <(echo "$json_content" | jq --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select((.value["common"] != null or .value[$os] != null) and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | (.value["common"][]?, .value[$os][]?) | select(.method == $method) | .name | select(. != null)' && printf '\0')

    if [ ${#package_names[@]} -eq 0 ]; then
        continue
    fi

    if [ "$method" != "brew" ] &&  [ "$method" != "cask" ] && [ "$method" != "mas" ]; then
        echo "title \"Install/Update packages from ${method}\""  >> "$install_script_path"
    fi
    install_cmd=""
    update_cmd=""
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
        nix)
            packages=$(printf '    %s\n' "${package_names[@]}")
            username="$USER"
            homeDirectory="$HOME"

            mkdir -p "$home_manager_dir"
            nix_user_path="${home_manager_dir}/user.nix"
            nix_packages_path="${home_manager_dir}/home.nix"
            printf '{ config, pkgs, ... }:\n{\n  home.username = \"%s\";\n  home.homeDirectory = \"%s\";\n  home.stateVersion = \"23.11\";\n  home.extraOutputsToInstall = ["dev" "mu4e"];\n}\n' \
                   "${username}" \
                   "${homeDirectory}" \
                   > "$nix_user_path"
                        printf '{ config, pkgs, ... }:\n{\n  imports = [\n    ./user.nix\n  ];\n\n  home.packages = with pkgs; [\n%s\n  ];\n\n  programs.home-manager.enable = true;\n}\n' \
                   "${packages}" \
                   > "$nix_packages_path"
            ;;
        brew|cask)
            for package in "${package_names[@]}"; do
                echo "${method} \"${package}\"" >> "$brew_file"
            done
            ;;
        mas)
            for package in "${package_names[@]}"; do
                echo "${method} \"${package}\", id: ${package}" >> "$brew_file"
            done
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
