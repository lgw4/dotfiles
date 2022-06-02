#!/usr/bin/env zsh
# Configuration variables
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Configuration options
setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_HISTORY
setopt GLOB_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt MENU_COMPLETE
setopt NO_CASE_GLOB
setopt SHARE_HISTORY

# Completion settings
zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
