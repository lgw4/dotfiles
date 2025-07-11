# GitHub Copilot Instructions

## General Instructions

- This repository contains my dotfiles for various command line tools. The repository is managed by [Chezmoi](https://www.chezmoi.io).
- These dotfiles are primarily used on macOS hosts, but are also intended to work on Debian/Ubuntu hosts.
- These dotfiles primarily support Fish shell (`fish`).
- These dotfiles secondarily support Bash shell (`bash`).
- These dotfiles also support a minimal Z shell (`zsh`) configuration since this is the default shell on macOS.
- When creating YAML files, **always** use the file extension `.yaml` (_never_ `.yml`).

## Machine Architecture Instructions

- All my macOS machines are now Apple silicon (also known as _darwin-arm64_ or _macos-arm64_). This repository should assume Apple silicon architecture on macOS.
- On Debian/Ubuntu machines, we cannot assume an architecture. Debian/Ubuntu machines will either be ARM architecture (_amd64_) or Intel architecture (*x86_64*). Where machine architecture may be a factor, there should be a Chezmoi test to determine the machine architecture.

## Shell Instructions

- When creating files meant to be executed, read, or sourced by `bash`, use the `.bash` filename extension.
- When creating files meant to be executed, read, or sourced by `fish`, use the `.fish` filename extension.
- When creating files meant to be executed, read, or sourced by `zsh`, use the `.zsh` filename extension.
- When creating general purpose shell scripts, prefer basic Bourne shell (also known as `sh`) without a filename extension. Make the script executable (for example: `chmod 755 example-script-name`). Use the file header `#!/usr/bin/env sh` to ensure finding the correct `sh` executable.
## Tools Instructions

- [`1Password`](https://1password.com) is used to store secrets that should not be stored in version control. The [`op`](https://developer.1password.com/docs/cli/) should be installed on each machine. Chezmoi has built-in support for retrieving secrets from 1Password.
- `apt` is preferred to `apt-get` when installing software on Debian/Ubuntu hosts.
- [`goenv`](https://github.com/go-nv/goenv) is used for Golang version management.
- [Hammerspoon](https://www.hammerspoon.org) for additional window management and general UI scripting on macOS machines.
- [Homebrew](https://brew.sh) is use for installing command line tools and graphical user interface applications (using the `--cask` option) on macOS.
- [`nodenv`](https://github.com/nodenv/nodenv) is used for NodeJS version management.
- [`rbenv`](https://github.com/rbenv/rbenv) is used for Ruby version management.
- [Starship](https://starship.rs) is the prompt tool used for Fish shell and Bash shell.
- [`uv`](https://docs.astral.sh/uv/) is used for Python version management, Python virtual environment management, and Python dependency management.
