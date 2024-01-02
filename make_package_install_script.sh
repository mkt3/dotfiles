#!/usr/bin/env bash

set -eu
set -o pipefail

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
common_methods=("cargo" "pipx" "go" "npm")

toml_file=${TOML_FILE:-"./toml_file"}
install_script_path=${INSTALL_SCRIPT:-"./results/install_packages.sh"}

brew_file="${REPO_DIR:-.}/results/Brewfile"

json_content=$(yj -t < "$toml_file")

setup_files="${REPO_DIR:-.}/scripts/**/setup.sh"
for filepath in $setup_files; do
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
    . "$filepath"
done

EOF


# pre functions
IFS=$'\n' read -r -d '' -a functions < <(echo "$json_content" | jq --arg os "$os_name" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select(.value[$os] != null and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) |  .value[$os][] | .function | select(. != null)' && printf '\0')

echo "# pre functions" >> "$install_script_path"
for func in "${functions[@]}"; do
    if type "pre_${func}" &> /dev/null; then
        echo "pre_${func}" >> "$install_script_path"
    fi
done

# packages
echo "# package install commands" >> "$install_script_path"

if [[ "$os_name" == "macos" ]]; then
    echo -n > "$brew_file"

    {
        echo "brew bundle --file $brew_file"
        echo "brew upgrade"
        echo "brew cleanup"
    } >> "$install_script_path"
fi

for method in ${methods[$os_name]} "${common_methods[@]}"; do
    IFS=$'\n' read -r -d '' -a package_names < <(echo "$json_content" | jq --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select(.value[$os] != null and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | .value[$os][] | select(.method == $method) | .name | select(. != null)' && printf '\0')

    if [ ${#package_names[@]} -eq 0 ]; then
        continue
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
        "go")
            install_cmd="go install"
            ;;
        "pipx")
            install_cmd="pipx install"
            update_cmd="pipx upgrade --include-injected"
            ;;
        "npm")
            install_cmd="sudo npm install -g"
            package_names=("${package_names[@]/%/@latest}")
            ;;
    esac

    case "$method" in
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
        pipx)
            for package in "${package_names[@]}"; do
                echo "${update_cmd} ${package} || ${install_cmd} ${package}"  >> "$install_script_path"
            done

            ;;
        go|cargo)
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
        echo "post_${func}" >> "$install_script_path"
    fi
done
