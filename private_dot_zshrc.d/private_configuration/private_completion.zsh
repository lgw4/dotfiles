# zsh/complist implements menu-select; it is not autoloaded by compinit.
zmodload zsh/complist

# Raise past the default of 100 so large lists (e.g. `brew` has 113
# subcommands) go straight to listing instead of stopping at
# "do you wish to see all N possibilities?" first.
LISTMAX=100000

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''

# Page long completion lists a screenful at a time instead of dumping
# them past the terminal -- without this, LISTMAX above just prints
# everything in one unbroken burst.
zstyle ':completion:*' list-prompt '%SAt %p: TAB for more, or the character to insert%s'
