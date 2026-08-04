[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# dotfiles

## Personal Use Notice
This repository contains configuration files and scripts for my personal use. They are shared publicly for reference but are tailored to my specific needs and setup.

## Overview
This repository manages my shell, editor, terminal, and OS-level setup with Nix as the main entrypoint.

It is not a plain collection of dotfiles. The repository also contains:

- bootstrap scripts for first-time setup
- package definitions in `packages.toml`
- Nix expressions that read the package catalog directly, plus a small script that executes apt on Ubuntu
- host-specific Nix configurations for macOS and NixOS

## Supported OS
- macOS
- Ubuntu (CLI only)
- NixOS

## Repository Structure
- `install.sh`: bootstrap entrypoint. Installs Nix if needed, clones this repository if missing, and runs `make`.
- `Makefile`: orchestrates environment setup, package application, updates, and checks.
- `packages.toml`: package catalog. Packages are grouped by type (`basic`, `dev`, `gui`) and install method.
- `scripts/`: shell scripts for bootstrap, environment prompts, package application, and Nix setup.
- `nix/home-manager/`: Home Manager modules for user-level configuration.
- `nix/systems/darwin/`: nix-darwin modules for macOS.
- `nix/systems/nixos/`: NixOS modules for system-level Linux configuration.
- `results/`: machine-local state such as `env_settings`.
- `~/.config/nix/host.json`: generated machine-local input containing the OS, platform, and host-specific values consumed by the flake.

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
   - evaluates Nix, Homebrew, and apt package selections directly from `packages.toml`
   - prepares a flake in `~/.config/nix`
   - applies the configuration

## OS-specific Behavior
- macOS: applies system configuration through `nix-darwin` and Home Manager. Homebrew packages are selected directly from `packages.toml` by the nix-darwin module.
- Ubuntu: applies user configuration through Home Manager.
- NixOS: applies system configuration through `nixos-rebuild` and Home Manager.

The package source can differ by OS. Some packages are installed via Nix, some via Home Manager modules, and some platform-specific packages may use native package managers or nix-darwin's Homebrew integration.

## Update
Run the installer again:

```bash
sh <(curl -sSL https://raw.githubusercontent.com/mkt3/dotfiles/main/install.sh)
```

This reuses the existing repository and current environment settings. Run `make reset-env` to remove the saved hostname and dev/GUI choices before the next apply.

For local operation after bootstrap:

```bash
make apply
```

applies your current configuration using the repository's tracked `nix/flake.lock`.
The generated flake reads `host.json` as a regular source file, so applying and checking it do not require impure evaluation.
Repository-managed Nix directories, including `flake.lock`, are replaced during preparation, while the machine-local `nix.conf` remains in `~/.config/nix`.
Apply, update, and upgrade operations use a per-user process lock so that two terminals cannot modify the configuration concurrently.
It also refreshes this repository's `pre-commit` hooks when `.pre-commit-config.yaml` is present.
Use this when you want to reflect your own config changes without pulling newer upstream inputs.

```bash
make update
```

updates the repository without switching the system. Nix inputs are updated by
the metis-plus cache builder, which commits a new `nix/flake.lock` only after its
NixOS cache target has been built and pushed successfully. This keeps the lock
published on `main` aligned with the contents available from Attic.

```bash
make upgrade
```

updates and then applies the configuration.
This is the normal command when you want to keep the environment current.
On Ubuntu, it also upgrades the multi-user Nix installation before applying the configuration.
As part of `make apply`, it also refreshes this repository's `pre-commit` hooks automatically.

`make` without a target behaves the same way as `make upgrade`.

```bash
make upgrade-nix
```

upgrades only the multi-user Nix installation on Ubuntu.

```bash
make help
```

shows the available local commands.

```bash
make check
```

runs the local verification flow used to catch the same class of issues as CI before pushing changes.

## Homelab Nix Cache

Linux hosts use the LAN-only Attic cache at
`https://attic.mkt3.dev/dotfiles`. The Nix daemon is configured to fall back to
other substituters or local builds when the homelab cache is unavailable, so
being away from the LAN does not make the cache a deployment dependency.
macOS hosts continue to build normally without using Attic.

Update the shared lock in the synthetic cache-builder environment with:

```bash
make update-cache-flake-lock
```

This command is intended for the metis-plus cache builder. Build the maximal
NixOS profile used to warm the shared cache with:

```bash
make build-cache-targets
```

This builds a NixOS CUI/dev/GUI system profile from the repository's committed
`flake.lock`, using temporary generated host inputs. Its closure contains the
shared Nix packages needed by the smaller profiles, so Ubuntu keeps its normal
per-machine Home Manager build and reuses matching paths from Attic. The
command prints the resulting store path so the metis-plus cache builder can
push its closure. Push credentials belong only on that server and must not be
committed.

Attic skips unchanged paths and paths signed by the configured NixOS and
Numtide upstream caches. Linux clients only need the public cache key; they do
not need push credentials.

## Development Notes
### Package changes
If you update `packages.toml`, Nix, Home Manager, nix-darwin Homebrew, and Ubuntu apt packages are selected by Nix evaluation. The tracked apply script executes the resulting apt command on Ubuntu.

### `packages.toml` conventions
Each table in `packages.toml` represents one logical package group.

- `type = "basic"`: always included
- `type = "dev"`: included only when `DEV_ENV=y`
- `type = "gui"`: included only when `GUI_ENV=y`

The supported package source keys are:

- `common`: used on every supported platform
- `linux`: added on Linux platforms in addition to `common`
- `ubuntu`, `darwin`, `nixos`: platform-specific additions

The supported install methods are:

- `nix`: install as a regular Nix package
- `nix-hm`: install through Home Manager, usually for user packages or program modules
- `apt`: install through Ubuntu's native package manager
- `brew`, `cask`, `mas`: rendered into nix-darwin's Homebrew module on macOS

Entries using `mas` must provide an App Store ID separately, for example `{ name = "Xcode", id = 497799835, method = "mas" }`.

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
make check-format
make check-catalog
make check-shell
make check-workflow
make check-flake
make check-nixos
make lint
```

Use `make check` before pushing to run the complete suite. During development, the individual `check-*` targets provide faster feedback for the area being changed.

## CI
GitHub Actions runs lightweight checks on Ubuntu and macOS for pushes and pull requests to `main`.

Current CI covers:

- `taplo fmt --check` for `packages.toml`
- Nix-based schema and duplicate validation for `packages.toml`
- `shellcheck` for every shell script in the working tree
- `actionlint` for GitHub Actions workflows
- `nix flake show` against the generated flake layout
- closure evaluation for Ubuntu Home Manager, NixOS, and nix-darwin configurations

CI does not perform full machine setup. It does not run `darwin-rebuild switch`, `nixos-rebuild switch`, GUI app installation, or App Store dependent flows.

## Known Constraints
- This repository is optimized for my own machines and preferences.
- Linux support outside NixOS is mainly CLI-oriented.
- Some macOS setup still assumes manual steps or host-specific state.
- Generated files in `results/` are local artifacts, not the source of truth.

## Links
[Emacs config](./nix/home-manager/programs/emacs)
