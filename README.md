# dotfiles

## install ansible
- arch linux
```bash
sudo pacman -S ansible
```

- mac
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install ansible
```

- ubuntu
```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

## setup
```bash
git clone https://github.com/mkt3/dotfiles .dotfiles
cd .dotfiles
./setup.sh
```
