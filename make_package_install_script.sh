#!/usr/bin/env bash

set -eu
set -o pipefail

os_name=""

case "$DISTRO" in
    "Arch") os_name="arch" ;;
    "Ubuntu") os_name="ubuntu" ;;
    "Darwin") os_name="macos" ;;
    *) echo "${DISTRO} is not supported."; exit 1 ;;
esac

dev_env=${DEV_ENV:-n}
gui_env=${GUI_ENV:-n}

declare -A methods
methods["ubuntu"]="apt"
methods["macos"]="brew cask mas"
methods["arch"]="pacman aur"
common_methods=("cargo" "pipx" "go" "npm")

toml_file="./packages.toml"
output_file="./results/install_package.sh"
brew_file="./results/Brewfile"

json_content=$(yj -t < "$toml_file")


echo '. "./files/zsh/zshenv.zsh"'  > "$output_file"
echo '. "./scripts/install_essential_packages.sh"' >> "$output_file"

if [[ "$os_name" == "macos" ]]; then
    echo -n > "$brew_file"
    {
        echo "brew bundle --file $brew_file"
        echo "brew upgrade"
        echo "brew cleanup"
    } >> "$output_file"
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
            install_cmd="npm install -g"
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
                echo "${update_cmd} ${package} || ${install_cmd} ${package}"  >> "$output_file"
            done

            ;;
        go|cargo)
            for package in "${package_names[@]}"; do
                echo "${install_cmd} ${package}" >> "$output_file"
            done
            ;;
        *)
            echo "${install_cmd} ${package_names[*]}" >> "$output_file"
            ;;
    esac
done
