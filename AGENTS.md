# Dotfiles (chezmoi)

This repo manages personal dotfiles via [chezmoi](https://www.chezmoi.io).

## Chezmoi filename conventions

- `dot_` prefix → `.` in the home directory (e.g. `dot_bashrc` → `~/.bashrc`)
- `private_` prefix → file is created with mode 0600
- `.tmpl` suffix → Go template; rendered with chezmoi data before applying
- `executable_` prefix → file is made executable

## Working with templates

Templates use `{{ .chezmoi.* }}` variables (e.g. `{{ .chezmoi.os }}`, `{{ .chezmoi.hostname }}`). Data is defined in `~/.config/chezmoi/chezmoi.toml` on each machine — do not commit secrets there.

## Testing changes

```sh
chezmoi diff        # preview what would change on the local machine
chezmoi apply       # apply changes
chezmoi doctor      # check for configuration issues
```
