# dotfiles

## install ansible
- arch linux
```bash
sudo pacman -S ansible
```

- mac
```bash
sudo pip install ansibe
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
