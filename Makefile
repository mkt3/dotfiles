INSTALL_DIR ?= $(HOME)/workspace/ghq/github.com/mkt3/dotfiles

# 環境設定ファイル
ENV_FILE := ./results/env_settings

DISTRO := $(shell uname -s)
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell awk '{print $1; exit}' /etc/issue)
endif
RESULTS = ./results

all: install-repository install-package

.PHONY: install-package
install-package: $(RESULTS)/install_package.sh
	@echo "package install"
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) \
	/usr/bin/env bash "$(RESULTS)/install_packages.sh"

.PHONY: install-repository
install-repository: $(ENV_FILE)
	@git -C "$(INSTALL_DIR)" pull || git clone https://github.com/mkt3/dotfiles "$(INSTALL_DIR)"
	@echo $(DISTRO)

$(RESULTS)/install_package.sh: packages.toml $(INSTALL_DIR)/make_package_install_script.sh $(ENV_FILE)
	@echo "Making package install scripts.."
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@DISTRO=$(DISTRO) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) \
    /usr/bin/env bash "$(INSTALL_DIR)/make_package_install_script.sh"

$(ENV_FILE):
	@if [ ! -f $(ENV_FILE) ]; then \
		mkdir -p $(RESULTS); \
		ENV_FILE=$(ENV_FILE) /usr/bin/env bash ./scripts/setup_env.sh; \
	fi

.PHONY: clean
clean:
	rm -rf $(RESULTS)
