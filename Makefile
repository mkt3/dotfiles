export
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RESULTS_DIR := $(REPO_DIR)/results
TOML_FILE := $(REPO_DIR)/packages.toml
ENV_FILE := $(RESULTS_DIR)/env_settings
INSTALL_SCRIPT := $(RESULTS_DIR)/install_packages.sh
MAKE_INSTALL_SCRIPT := $(REPO_DIR)/scripts/make_package_install_script.sh
DISTRO := $(shell uname -s)
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell awk '{print $$1; exit}' /etc/issue)
endif

all: clone_repository $(ENV_FILE) install_essential_packages $(INSTALL_SCRIPT) install_packages

.PHONY: install_packages
install_packages: $(ENV_FILE)
	@DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) /usr/bin/env bash "$(INSTALL_SCRIPT)"

.PHONY: install_essential_packages
install_essential_packages:
	@/usr/bin/env bash "$(REPO_DIR)/scripts/install_essential_packages.sh"

.PHONY: clone_repository
clone_repository:
	@git -C "$(REPO_DIR)" pull || git clone https://github.com/mkt3/dotfiles "$(REPO_DIR)"

.PHONY: $(INSTALL_SCRIPT)
$(INSTALL_SCRIPT): $(ENV_FILE) $(TOML_FILE) $(MAKE_INSTALL_SCRIPT)
	@DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) /usr/bin/env bash $(MAKE_INSTALL_SCRIPT)

.PHONY: $(ENV_FILE)
$(ENV_FILE):
	@if [ ! -f $(ENV_FILE) ]; then \
		mkdir -p $(RESULTS_DIR); \
		/usr/bin/env bash $(REPO_DIR)/scripts/setup_env.sh; \
	fi
	@$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))

.PHONY: clean
clean:
	rm -rf $(RESULTS_DIR)

.PHONY: lint
lint:
	taplo fmt --config $(REPO_DIR)/taplo.toml $(TOML_FILE)

.PHONY: import_mkt3_public_key
import_mkt3_public_key:
	gpg --fetch-key https://github.com/mkt3.gpg
	gpg --edit-key makoto@mkt3.dev trust quit

.PHONY: my-git
my-git:
	git config --global user.name "Makoto Morinaga"
	git config --global user.email makoto@mkt3.dev
