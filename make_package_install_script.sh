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
common_methods=("cargo" "pipx" "go")

toml_file="./packages.toml"
output_file="./results/install_package.sh"
brew_file="./results/Brewfile"

json_content=$(yj -t < "$toml_file")


echo '. "./files/zsh/zshenv.zsh"'  > "$output_file"
echo '. "./scripts/install_essential_packages.sh"' >> "$output_file"

if [[ "$os_name" == "macos" ]]; then
    {
        echo "brew bundle --file $brew_file"
        echo "brew upgrade"
        echo "brew cleanup"
    } >> "$output_file"
fi

for method in ${methods[$os_name]} "${common_methods[@]}"; do
    package_names=$(echo "$json_content" | jq --arg os "$os_name" --arg method "$method" --arg dev_env "$dev_env" --arg gui_env "$gui_env" -r 'to_entries | .[] | select(.value[$os] != null and (.value.type == "basic" or ($dev_env == "y" and .value.type == "dev") or ($gui_env == "y" and .value.type == "gui"))) | .value[$os][] | select(.method == $method) | .name | select(. != null)' | tr '\n' ' ')

    if [ -z "$package_names" ]; then
        continue
    fi

    install_cmd=""
    case "$method" in
        "apt") install_cmd="sudo apt-get -y install" ;;
        "pacman") install_cmd="sudo pacman -S --needed --noconfirm" ;;
        "aur") install_cmd="yay -S --needed --noconfirm" ;;
        "cargo") install_cmd='"${CARGO_HOME}/bin/rustup" run stable cargo install'
    esac

    case "$method" in
        brew|cask)
            for package in ${package_names}; do
                echo "${method} \"${package}\" " >> "$brew_file"
            done
            ;;
        mas)
            for package in ${package_names}; do
                echo "${method} \"${package}\", id: ${package}" >> "$brew_file"
            done
            ;;
        pipx)
            installed_pipx_list=$(pipx list)

            for package in ${package_names}; do
                if [[ $installed_pipx_list =~ package\ "$package" ]]; then
                    echo "pipx upgrade --include-injected ${package}"  >> "$output_file"

                else
                    echo "pipx install ${package}"  >> "$output_file"
                fi
            done
            ;;
        go)
            for package in ${package_names}; do
                echo "go install ${package}" >> "$output_file"
            done
            ;;
        *)
            echo "${install_cmd} ${package_names}" >> "$output_file"
            ;;
    esac

done
