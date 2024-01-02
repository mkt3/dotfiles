REPO_DIR := $(CURDIR)
RESULTS_DIR := $(REPO_DIR)/results
TOML_FILE := $(REPO_DIR)/packages.toml
ENV_FILE := $(RESULTS_DIR)/env_settings
INSTALL_SCRIPT := $(RESULTS_DIR)/install_packages.sh
DISTRO := $(shell uname -s)
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell awk '{print $$1; exit}' /etc/issue)
endif


all: clone_repository  $(ENV_FILE) install_essential_packages $(INSTALL_SCRIPT) install-packages

.PHONY: install-packages
install-packages:
	@echo "package install"
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	REPO_DIR=$(REPO_DIR) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) \
	/usr/bin/env bash "$(INSTALL_SCRIPT)"

.PHONY: install_essential_packages
install_essential_packages:
	@echo "essential package install"
	REPO_DIR=$(REPO_DIR) \
	/usr/bin/env bash "$(REPO_DIR)/scripts/install_essential_packages.sh"

.PHONY: clone_repository
clone_repository:
	@git -C "$(REPO_DIR)" pull || git clone https://github.com/mkt3/dotfiles "$(REPO_DIR)"

$(INSTALL_SCRIPT): $(ENV_FILE) $(TOML_FILE) $(REPO_DIR)/make_package_install_script.sh
	@echo "Making package install scripts.."
	$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@DISTRO=$(DISTRO) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV)  REPO_DIR=$(REPO_DIR) \
	TOML_FILE=$(TOML_FILE) INSTALL_SCRIPT=$(INSTALL_SCRIPT) \
    /usr/bin/env bash "$(REPO_DIR)/make_package_install_script.sh"

$(ENV_FILE):
	@if [ ! -f $(ENV_FILE) ]; then \
		mkdir -p $(RESULTS_DIR); \
		ENV_FILE=$(ENV_FILE) /usr/bin/env bash $(REPO_DIR)/scripts/setup_env.sh; \
	fi

.PHONY: clean
clean:
	rm -rf $(RESULTS_DIR)
