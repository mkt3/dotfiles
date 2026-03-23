[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# dotfiles

## Personal Use Notice
This repository contains configuration files and scripts for my personal use. They are shared publicly for reference but are tailored to my specific needs and setup.

## Overview
This repository manages my shell, editor, terminal, and OS-level setup with Nix as the main entrypoint.

It is not a plain collection of dotfiles. The repository also contains:

- bootstrap scripts for first-time setup
- package definitions in `packages.toml`
- scripts that generate Nix modules and install scripts
- host-specific Nix configurations for macOS and NixOS

## Supported OS
- macOS
- Ubuntu (CLI only)
- Arch Linux (CLI only)
- NixOS

## Repository Structure
- `install.sh`: bootstrap entrypoint. Installs Nix if needed, clones this repository if missing, and runs `make`.
- `Makefile`: orchestrates environment setup, package script generation, and package application.
- `packages.toml`: package catalog. Packages are grouped by type (`basic`, `dev`, `gui`) and install method.
- `scripts/`: shell scripts for bootstrap, environment prompts, install script generation, and Nix setup.
- `nix/home-manager/`: Home Manager modules for user-level configuration.
- `nix/systems/darwin/`: nix-darwin modules for macOS.
- `nix/systems/nixos/`: NixOS modules for system-level Linux configuration.
- `results/`: generated local artifacts such as `env_settings` and generated Nix files.

## Installation
### First-time setup
1. On macOS, sign in to the App Store manually if you use App Store apps.
2. Run:

```bash
sh <(curl -sSL https://raw.githubusercontent.com/mkt3/dotfiles/main/install.sh)
```

3. During setup, the installer asks for:
   - `HOSTNAME_ENV`: unique host name used for system selection
   - `DEV_ENV`: whether to install development tooling
   - `GUI_ENV`: whether to install desktop / GUI packages

These values are stored in `results/env_settings`.

### What `install.sh` does
`install.sh` performs the following steps:

1. Install Nix if it is not already available.
2. Load the Nix environment into the current shell.
3. Clone this repository into `~/workspace/ghq/github.com/mkt3/dotfiles` if it does not already exist.
4. Run `make`, which:
   - prompts for environment settings if needed
   - installs essential non-Nix prerequisites
   - generates package install artifacts from `packages.toml`
   - prepares a flake in `~/.config/nix`
   - applies the configuration

## OS-specific Behavior
- macOS: applies system configuration through `nix-darwin` and Home Manager.
- Ubuntu / Arch Linux: applies user configuration through Home Manager.
- NixOS: applies system configuration through `nixos-rebuild` and Home Manager.

The package source can differ by OS. Some packages are installed via Nix, some via Home Manager modules, and some platform-specific packages may use native package managers or Homebrew-related configuration.

## Update
Run the installer again:

```bash
sh <(curl -sSL https://raw.githubusercontent.com/mkt3/dotfiles/main/install.sh)
```

This reuses the existing repository and current environment settings unless you remove `results/env_settings`.

For local operation after bootstrap:

```bash
make apply
```

applies your current configuration using the existing `flake.lock`.
It also refreshes this repository's `pre-commit` hooks when `.pre-commit-config.yaml` is present.
Use this when you want to reflect your own config changes without pulling newer upstream inputs.

```bash
make update
```

updates the repository and Nix inputs without switching the system.
This is mainly useful when you want to inspect or verify updates before applying them.

```bash
make upgrade
```

updates and then applies the configuration.
This is the normal command when you want to keep the environment current.
As part of `make apply`, it also refreshes this repository's `pre-commit` hooks automatically.

`make` without a target behaves the same way as `make upgrade`.

```bash
make help
```

shows the available local commands.

```bash
make check
```

runs the local verification flow used to catch the same class of issues as CI before pushing changes.

## Development Notes
### Package changes
If you update `packages.toml`, the repository generates install artifacts and Nix fragments under `results/generated/`.

### `packages.toml` conventions
Each table in `packages.toml` represents one logical package group.

- `type = "basic"`: always included
- `type = "dev"`: included only when `DEV_ENV=y`
- `type = "gui"`: included only when `GUI_ENV=y`

The supported package source keys are:

- `common`: used on every supported platform
- `linux`: added on Linux platforms in addition to `common`
- `ubuntu`, `arch`, `darwin`, `nixos`: platform-specific additions

The supported install methods are:

- `nix`: install as a regular Nix package
- `nix-hm`: install through Home Manager, usually for user packages or program modules
- `apt`, `pacman`, `aur`: install through native Linux package managers
- `brew`, `cask`, `mas`: used for macOS Homebrew and App Store integration

When a package `name` matches a directory under `nix/home-manager/programs/` or `nix/systems/*/programs/`, it is treated as a module import instead of a plain package name.
Use `nix-hm` for Home Manager program modules and `nix` for system-level modules when applicable.

### Environment settings
The installer stores local decisions in:

```text
results/env_settings
```

Example:

```text
HOSTNAME_ENV=my-host
DEV_ENV=y
GUI_ENV=n
```

### Manual checks
Useful local checks:

```bash
make help
make check
make lint
```

## CI
GitHub Actions runs lightweight checks on Ubuntu and macOS for pushes and pull requests to `main`.

Current CI covers:

- `taplo fmt --check` for `packages.toml`
- `shellcheck` for bootstrap and setup scripts
- generation of install artifacts from `packages.toml`
- `nix flake show` against the generated flake layout

CI does not perform full machine setup. It does not run `darwin-rebuild switch`, `nixos-rebuild switch`, GUI app installation, or App Store dependent flows.

## Known Constraints
- This repository is optimized for my own machines and preferences.
- Linux support outside NixOS is mainly CLI-oriented.
- Some macOS setup still assumes manual steps or host-specific state.
- Generated files in `results/` are local artifacts, not the source of truth.

## Links
[Emacs config](./nix/home-manager/programs/emacs)
