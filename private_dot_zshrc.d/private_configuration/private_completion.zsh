# zsh/complist implements menu-select; it is not autoloaded by compinit.
zmodload zsh/complist

# Raise past the default of 100 so large lists (e.g. `brew` has 113
# subcommands) go straight into the scrollable menu instead of stopping
# at "do you wish to see all N possibilities?" first.
LISTMAX=100000

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''
