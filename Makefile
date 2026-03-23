export
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RESULTS_DIR := $(REPO_DIR)/results
TOML_FILE := $(REPO_DIR)/packages.toml
ENV_FILE := $(RESULTS_DIR)/env_settings
INSTALL_SCRIPT := $(RESULTS_DIR)/install_packages.sh
MAKE_INSTALL_SCRIPT := $(REPO_DIR)/scripts/make_package_install_script.sh
DISTRO := $(shell uname -s)
NIX_CMD := nix --extra-experimental-features "nix-command flakes"
ifeq ($(DISTRO),Linux)
    DISTRO := $(shell grep -oP '(?<=^NAME=).+' /etc/os-release | tr -d '"')
endif

.PHONY: all
all: upgrade

.PHONY: help
help:
	@printf "%s\n" \
		"make apply    Apply current config with existing flake.lock" \
		"make update   Pull repo and update flake.lock without applying" \
		"make upgrade  Update and then apply configuration" \
		"make check    Run local checks similar to CI" \
		"make lint     Format packages.toml with taplo" \
		"make clean    Remove generated artifacts under results/"

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
	@git -C "$(REPO_DIR)" pull --ff-only

.PHONY: prepare_nix
prepare_nix: $(INSTALL_SCRIPT)
	@HOSTNAME_ENV=$(HOSTNAME_ENV) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) REPO_DIR="$(REPO_DIR)" /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/common.sh"; CONFIGS_DIR="$(REPO_DIR)/nix"; . "$(REPO_DIR)/scripts/nix/setup.sh"; pre_setup_nix'

.PHONY: update_flake_lock
update_flake_lock: prepare_nix
	@cd "$(HOME)/.config/nix" && $(NIX_CMD) flake update

.PHONY: install_essential_packages
install_essential_packages:
	@/usr/bin/env bash "$(REPO_DIR)/scripts/install_essential_packages.sh"

.PHONY: $(INSTALL_SCRIPT)
$(INSTALL_SCRIPT): setup_env $(TOML_FILE) $(MAKE_INSTALL_SCRIPT)
	@DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) . "${REPO_DIR}/nix/home-manager/programs/zsh/env.sh" && $(NIX_CMD) run nixpkgs#bash $(MAKE_INSTALL_SCRIPT)

.PHONY: install_packages
install_packages: $(INSTALL_SCRIPT)
	@HOSTNAME_ENV=$(HOSTNAME_ENV) DEV_ENV=$(DEV_ENV) GUI_ENV=$(GUI_ENV) /usr/bin/env bash "$(INSTALL_SCRIPT)"

.PHONY: install_git_hooks
install_git_hooks:
	@REPO_DIR="$(REPO_DIR)" /usr/bin/env bash "$(REPO_DIR)/scripts/install_git_hooks.sh"

.PHONY: apply
apply: setup_env install_essential_packages install_packages install_git_hooks

.PHONY: update
update: setup_env update_repository update_flake_lock

.PHONY: upgrade
upgrade: update apply

.PHONY: clean
clean:
	rm -rf $(RESULTS_DIR)

.PHONY: check
check:
	@mkdir -p "$(RESULTS_DIR)"
	@$(NIX_CMD) shell nixpkgs#taplo --command taplo fmt --check --config "$(REPO_DIR)/taplo.toml" "$(TOML_FILE)"
	@$(NIX_CMD) shell nixpkgs#shellcheck --command shellcheck "$(REPO_DIR)/install.sh" "$(REPO_DIR)"/scripts/*.sh "$(REPO_DIR)"/scripts/nix/*.sh
	@REPO_DIR="$(REPO_DIR)" TOML_FILE="$(TOML_FILE)" INSTALL_SCRIPT="$(INSTALL_SCRIPT)" DEV_ENV=y GUI_ENV=y GITHUB_ACTIONS=y /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/common.sh"; nix --extra-experimental-features "nix-command flakes" run nixpkgs#bash -- "$(REPO_DIR)/scripts/make_package_install_script.sh"'
	@REPO_DIR="$(REPO_DIR)" HOSTNAME_ENV=check-host DEV_ENV=y GUI_ENV=y /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/common.sh"; CONFIGS_DIR="$(REPO_DIR)/nix"; . "$(REPO_DIR)/scripts/nix/setup.sh"; pre_setup_nix; nix --extra-experimental-features "nix-command flakes" flake show "$(HOME)/.config/nix"'

.PHONY: lint
lint:
	-@RUST_LOG=warn taplo fmt --config $(REPO_DIR)/taplo.toml $(TOML_FILE)

.PHONY: import_mkt3_public_key
import_mkt3_public_key:
	gpg --fetch-key https://github.com/mkt3.gpg
	gpg --edit-key makoto@mkt3.dev trust quit
