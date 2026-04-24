# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io). Primary target is macOS (Apple silicon); secondary target is Debian/Ubuntu (arch must be detected, never assumed). Windows is partially supported via `.chezmoiignore` exclusions.

Shell support, in priority order: **fish** (primary), **bash** (secondary), **zsh** (minimal — it's just macOS's default login shell).

## Working with chezmoi source files

This repo **is** the chezmoi source directory (`$(chezmoi source-path)` points here). Files here are not the files that land in `$HOME` — chezmoi renames them on `apply` using prefix conventions. When creating or renaming files, pick the right prefix or the file will land in the wrong place with the wrong permissions:

- `dot_` → `.` (e.g. `private_dot_bashrc` → `~/.bashrc`)
- `private_` → mode `0600` / `0700` (owner-only)
- `executable_` → mode `0755`
- `.tmpl` suffix → processed as a Go text/template with chezmoi's template functions (`.chezmoi.os`, `.chezmoi.hostname`, `onepasswordRead`, etc.)

When adding a script to `private_dot_local/private_bin/`, the filename must start with `private_executable_` for it to be installed as an executable in `~/.local/bin/`.

### Common commands

```sh
chezmoi diff                 # preview what `apply` would change in $HOME
chezmoi apply -v             # apply changes from this repo to $HOME
chezmoi apply <target>       # apply a single target (path in $HOME)
chezmoi execute-template < file.tmpl   # render a template to stdout for debugging
chezmoi edit <target-in-home>          # edit the source file that maps to a $HOME path
chezmoi cd                   # open a shell in the source directory (here)
```

After editing files **in this repo directly**, run `chezmoi diff` before `chezmoi apply` to confirm the rename/template resolution produces what you expect.

## Platform/host gating

Two layers of conditional logic, used together:

1. **`.chezmoiignore`** — Go templates decide which source files are *skipped entirely* per machine. Current rules gate macOS-only files (`hammerspoon`, several `bin/` scripts), work-machine-only files (ALKS config, `.netrc`, `.npmrcs`) behind a hostname check against a 1Password-stored hostname, and Linux-only files.
2. **`.tmpl` files** — Template conditionals (`{{ if eq .chezmoi.os "darwin" }}…{{ end }}`) branch *within* a file. Used heavily in fish `conf.d` and bashrc.d `tools/` for language-version-manager PATH setup (goenv/nodenv/rbenv/tenv/uv).

When adding a macOS-only binary, Linux-only config, or work-only secret, update `.chezmoiignore` rather than sprinkling conditionals inside a template — keep per-file skips in the ignore file, and per-section branching in `.tmpl`.

## Shell config layout

Both shells load config fragments from a directory so features can be added per-file without touching the main rc file:

- **bash**: [private_dot_bashrc](private_dot_bashrc) sources `~/.bashrc.d/**/*.bash` (globstar). Fragments live in [private_dot_bashrc.d/](private_dot_bashrc.d/) under `aliases/`, `configuration/`, `functions/`, `tools/`.
- **fish**: [private_dot_config/private_fish/](private_dot_config/private_fish/) uses fish's native `conf.d/` with a numeric prefix ordering convention — `00-path-*` (PATH setup first), `10-*` (aliases/abbreviations), `20-*`/`80-*` (tool config), `90-*` (env vars last). Preserve that ordering when adding fragments.

Both shells initialize **starship** and **direnv**, and rely on **Homebrew** (`/opt/homebrew/bin/brew` on Apple silicon, `/usr/local/bin/brew` on Intel fallback).

## Secrets

Secrets come from **1Password** via `onepasswordRead "op://Vault/item/field"` in templates — `op` CLI must be installed and signed in on every machine. Never hardcode secrets; never commit them. The work-machine gate (see `.chezmoiignore` line 19) reads a stored hostname from 1Password and uses it to decide whether to deploy work-only files.

## File conventions

From [.github/copilot-instructions.md](.github/copilot-instructions.md), also applicable here:

- Shell file extensions are load-bearing: `.bash`, `.fish`, `.zsh` for files sourced/executed by that specific shell. For portable scripts, prefer POSIX `sh` with no extension, `#!/usr/bin/env sh` shebang, and `chmod 755`.
- Always use `.yaml`, never `.yml`.
- Prefer `apt` over `apt-get` on Debian/Ubuntu.
- Language version managers in use: `goenv`, `nodenv`, `rbenv`, `tenv` (Terraform), `uv` (Python). Don't introduce alternatives (pyenv, nvm, asdf) without a reason.
