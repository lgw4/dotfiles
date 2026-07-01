# Set terminal window title before each prompt and before each command runs,
# so it isn't left stale (or reset by something else) while a command executes.
autoload -Uz add-zsh-hook

_set_terminal_title() {
    print -Pn "\e]0;%n@%m: %~\a"
}

add-zsh-hook precmd _set_terminal_title
add-zsh-hook preexec _set_terminal_title
