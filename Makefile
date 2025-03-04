export
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RESULTS_DIR := $(REPO_DIR)/results
TOML_FILE := $(REPO_DIR)/packages.toml
ENV_FILE := $(RESULTS_DIR)/env_settings
INSTALL_SCRIPT := $(RESULTS_DIR)/install_packages.sh
MAKE_INSTALL_SCRIPT := $(REPO_DIR)/scripts/make_package_install_script.sh
DISTRO := $(shell uname -s)
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell grep -oP '(?<=^NAME=).+' /etc/os-release | tr -d '"')
endif

.PHONY: all
all: setup_env update_repository install_essential_packages install_packages lint

.PHONY: create_env_file
create_env_file:
	@if [ ! -f $(ENV_FILE) ]; then \
		mkdir -p $(RESULTS_DIR); \
		/usr/bin/env bash $(REPO_DIR)/scripts/setup_env.sh; \
	fi

.PHONY: setup_env
setup_env: create_env_file
	@$(eval HOSTNAME_ENV=$(shell grep 'HOSTNAME_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@$(eval DEV_ENV=$(shell grep 'DEV_ENV' $(ENV_FILE) | cut -d '=' -f2))
	@$(eval GUI_ENV=$(shell grep 'GUI_ENV' $(ENV_FILE) | cut -d '=' -f2))

.PHONY: update_repository
update_repository:
	@git -C "$(REPO_DIR)" pull

.PHONY: install_essential_packages
install_essential_packages:
	@/usr/bin/env bash "$(REPO_DIR)/scripts/install_essential_packages.sh"

.PHONY: $(INSTALL_SCRIPT)
$(INSTALL_SCRIPT): setup_env $(TOML_FILE) $(MAKE_INSTALL_SCRIPT)
	@DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) nix run nixpkgs#bash $(MAKE_INSTALL_SCRIPT)

.PHONY: install_packages
install_packages: $(INSTALL_SCRIPT)
	@HOSTNAME_ENV=$(HOSTNAME_ENV) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) /usr/bin/env bash "$(INSTALL_SCRIPT)"

.PHONY: clean
clean:
	rm -rf $(RESULTS_DIR)

.PHONY: lint
lint:
	-@RUST_LOG=warn taplo fmt --config $(REPO_DIR)/taplo.toml $(TOML_FILE)

.PHONY: import_mkt3_public_key
import_mkt3_public_key:
	gpg --fetch-key https://github.com/mkt3.gpg
	gpg --edit-key makoto@mkt3.dev trust quit
