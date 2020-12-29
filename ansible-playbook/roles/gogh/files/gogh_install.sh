cd ~/.gogh/themes

# necessary on ubuntu
if [ "$(uname)" != "Darwin" ]; then
  export TERMINAL=gnome-terminal
fi

# install themes
./japanesque.sh
./dracula.sh
./zenburn.sh
