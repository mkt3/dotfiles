export
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RESULTS_DIR := $(REPO_DIR)/results
TOML_FILE := $(REPO_DIR)/packages.toml
ENV_FILE := $(RESULTS_DIR)/env_settings
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
	@REPO_DIR="$(REPO_DIR)" ENV_FILE="$(ENV_FILE)" /usr/bin/env bash "$(REPO_DIR)/scripts/load_env_settings.sh"

.PHONY: update_repository
update_repository:
	@git -C "$(REPO_DIR)" pull --ff-only

.PHONY: prepare_nix
prepare_nix: setup_env
	@REPO_DIR="$(REPO_DIR)" ENV_FILE="$(ENV_FILE)" /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/load_env_settings.sh"; . "$(REPO_DIR)/scripts/common.sh"; CONFIGS_DIR="$(REPO_DIR)/nix"; . "$(REPO_DIR)/scripts/nix/setup.sh"; pre_setup_nix'

.PHONY: update_flake_lock
update_flake_lock: prepare_nix
	@REPO_DIR="$(REPO_DIR)" ENV_FILE="$(ENV_FILE)" /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/load_env_settings.sh"; . "$(REPO_DIR)/scripts/common.sh"; . "$(REPO_DIR)/scripts/nix/setup.sh"; title "Setup GitHub token for Nix"; setup_nix_github_token_from_gh; cd "$(HOME)/.config/nix" && $(NIX_CMD) flake update'

.PHONY: install_essential_packages
install_essential_packages:
	@/usr/bin/env bash "$(REPO_DIR)/scripts/install_essential_packages.sh"

.PHONY: install_packages
install_packages: setup_env
	@REPO_DIR="$(REPO_DIR)" ENV_FILE="$(ENV_FILE)" /usr/bin/env bash -c '. "$(REPO_DIR)/scripts/load_env_settings.sh"; /usr/bin/env bash "$(REPO_DIR)/scripts/apply.sh"'

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
	@$(NIX_CMD) eval --raw --file "$(REPO_DIR)/nix/check-package-catalog.nix"
	@$(NIX_CMD) shell nixpkgs#ripgrep nixpkgs#shellcheck --command sh -c 'rg --files -0 -g "*.sh" "$$1" | xargs -0 shellcheck' sh "$(REPO_DIR)"
	@REPO_DIR="$(REPO_DIR)" HOSTNAME_ENV=check-host DEV_ENV=y GUI_ENV=y /usr/bin/env bash "$(REPO_DIR)/scripts/check_flake.sh"

.PHONY: lint
lint:
	@RUST_LOG=warn $(NIX_CMD) shell nixpkgs#taplo --command taplo fmt --config "$(REPO_DIR)/taplo.toml" "$(TOML_FILE)"

.PHONY: import_mkt3_public_key
import_mkt3_public_key:
	gpg --fetch-key https://github.com/mkt3.gpg
	gpg --edit-key makoto@mkt3.dev trust quit
