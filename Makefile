INSTALL_DIR ?= $(HOME)/workspace/ghq/github.com/mkt3/dotfiles


# 環境設定ファイル
ENV_FILE := ./results/env_settings

DISTRO := $(shell uname -s)
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell awk '{print $1; exit}' /etc/issue)
endif
RESULTS = ./results

all: check-env install package setup

.PHONY: setup
setup:
	@echo "setup"
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) \
	/usr/bin/env bash "$(INSTALL_DIR)/scripts/setup.sh"

.PHONY: package
package: $(RESULTS)/install_package.sh
	@echo "package install"
	/usr/bin/env bash "$(RESULTS)/install_package.sh"

.PHONY: install
install:
	@git -C "$(INSTALL_DIR)" pull || @git clone https://github.com/mkt3/dotfiles "$(INSTALL_DIR)"
	@echo $(DISTRO)


$(RESULTS)/install_package.sh: packages.toml $(INSTALL_DIR)/make_package_install_script.sh $(ENV_FILE)
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@echo "Making package install scripts.."
	@DISTRO=$(DISTRO) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) \
    /usr/bin/env bash "$(INSTALL_DIR)/make_package_install_script.sh"

.PHONY: check-env
check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		mkdir -p $(RESULTS); \
		ENV_FILE=$(ENV_FILE) /usr/bin/env bash ./scripts/setup_env.sh; \
	fi

.PHONY: clean
clean:
	rm -rf $(RESULTS)
