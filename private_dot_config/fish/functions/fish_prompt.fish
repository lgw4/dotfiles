function fish_prompt -d "Set prompt for Fish shell"
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
    echo
    set_color red
    printf '%s' $USER
    set_color normal
    printf ' at '

    set_color magenta
    printf '%s' (prompt_hostname)
    set_color normal
    printf ' in '

    set_color blue
    printf '%s' (basename (prompt_pwd))
    set_color normal

    set -g __fish_git_prompt_showcolorhints
    set -g __fish_git_prompt_showdirtystate
    set -g __fish_git_prompt_showuntrackedfiles
    printf '%s' (fish_git_prompt)

    if test -n "$VIRTUAL_ENV"
        printf " (%s)" (set_color CB4B16)(basename $VIRTUAL_ENV)(set_color normal)
    end

    # Line 2
    echo
    printf '> '
    set_color normal
end
