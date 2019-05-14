DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitignore
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

help:
	@echo "make list      #Show dotfiles in this repo"
	@echo "make deploy    #Create symlink to home directory"
	@echo "make init      #Setup environment settings"
	@echo "make update    #Fetch changes for this repo"
	@echo "make install   #Run make update, deploy, init"
	@echo "make clean     #Remove the dotfiles and this repo"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy:
	@echo "deploy dotfiles"
	@mkdir -p  $(HOME)/.config
	@ln -sfnv $(DOTPATH)/.vim  $(HOME)/.config/nvim
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@[ -e $(DOTPATH)/.emacs.d/ddskk.d/skk-record ] || touch $(DOTPATH)/.emacs.d/ddskk.d/skk-record
	@[ -e $(DOTPATH)/.emacs.d/snippets ] || mkdir $(DOTPATH)/.emacs.d/snippets
	@[ -e $(HOME)/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git $(HOME)/.fzf
	@[ -e $(HOME)/.zplugin ] || mkdir $(HOME)/.zplugin
	@[ -e $(HOME)/.zplugin/bin ] || git clone https://github.com/zdharma/zplugin.git $(HOME)/.zplugin/bin

init:
	@$(HOME)/.fzf/install --completion --key-bindings  --no-update-rc --no-bash

update:
	git pull origin master
	if [ -e $(HOME)/.fzf ]; then cd $(HOME)/.fzf && git pull origin master;fi
	if [ -e $(HOME)/.zplugin/bin ]; then cd $(HOME)/.zplugin/bin && git pull origin master;fi

install: update deploy init

clean:
	@echo "remove dotfiles"
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)
