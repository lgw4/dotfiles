# Set terminal window title before each prompt
_set_terminal_title() {
    print -Pn "\e]0;%n@%m: %~\a"
}
precmd_functions+=(_set_terminal_title)
