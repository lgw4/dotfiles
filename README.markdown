# `chezmoi`-managed dotfiles

My collection of [_dotfiles_](https://dotfiles.github.io) managed by [`chezmoi`](https://www.chezmoi.io). I'm working on using the templating afforded by `chezmoi` to eliminate the conditional platform-specific code in these dotfiles.

## Scripts

Files named `run_`, `run_once_`, or `run_onchange_` are scripts, not file targets. `chezmoi` renders them in memory and executes the result. It never writes them into `$HOME`, so they have no target path.

- `run_` runs before files are updated. `run_after_` runs afterwards.
- `run_onchange_` runs only when the rendered script content changes. `chezmoi` records a hash of the rendered content in `~/.config/chezmoi/chezmoistate.boltdb`.
- Force a re-run without editing the script: `chezmoi state delete-bucket --bucket=scriptState`.
- Preview the rendered script without running it: `chezmoi execute-template < run_onchange_something.sh.tmpl`.

## Herdr

Herdr keeps everything in `~/.config/herdr`, but most of it is runtime state that cannot be shared between machines. Only the portable parts live here.

### Managed

- `private_dot_config/private_herdr/config.toml`: user settings (theme, keybindings, terminal behavior). Applied to `~/.config/herdr/config.toml`.
- `run_onchange_install-herdr-plugins.sh.tmpl`: the plugins that should be installed, pinned to a commit.

After changing `config.toml`, run `chezmoi apply` and then `herdr server reload-config` so a running Herdr server picks it up. If a Herdr TUI setting writes to `config.toml` directly, run `chezmoi re-add ~/.config/herdr/config.toml` to adopt the change before the next `chezmoi apply` reverts it.

### Plugins

Herdr installs plugins as git checkouts under `~/.config/herdr/plugins/` and records them, with absolute paths, in `~/.config/herdr/plugins.json`. Neither is portable, so instead the script pins the intent: repository plus commit. It reads `herdr plugin list --json`, compares the installed `resolved_commit`, and calls `herdr plugin install --yes --ref <commit> <owner>/<repo>` only when the plugin is missing or pinned to a different commit.

`herdr plugin install` works without a running server, so the script is safe to run on a fresh machine via `chezmoi apply`. It exits without doing anything if `herdr` is not on `PATH` yet.

To add a plugin, add a line to the script:

```sh
ensure <owner> <repo> <commit>
```

To upgrade one, change the commit and reapply. Wrap macOS-only or Linux-only plugins in a template guard:

```sh
{{ if eq .chezmoi.os "darwin" -}}
ensure justinchiasson herdr-nudge 5b329f194ae4ec42825fc32b0958963aa65790e7
{{ end -}}
```

Plugin user settings live in `~/.config/herdr/plugins/config/<plugin-id>/`. Add that directory separately if a plugin needs configuration, since Herdr owns the rest of `plugins/`.

### Not managed

These are machine-specific, churn constantly, or contain no useful configuration:

| Path | Reason |
| --- | --- |
| `session.json` | Live layout with absolute working directories, project names, and agent session IDs |
| `session-snapshots/` | Rotating backups of the same layout data |
| `plugins.json` | Generated registry with absolute paths |
| `plugins/` | Third-party plugin git checkouts |
| `endpoints.json`, `endpoint-selection.json` | Saved SSH machines with hostnames and usernames |
| `herdr-server.log`, `herdr-client.log` | Runtime logs with paths and commands |
| `*.sock` | Live sockets |
| `release-notes.json` | Cached release metadata |
