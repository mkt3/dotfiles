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
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:

update:
	git pull origin master

install: update deploy init
	@exec $$SHELL

clean:
	@echo "remove dotfiles"
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTPATH)
