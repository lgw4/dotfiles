set fish_prompt_pwd_dir_length 0

if type -q pipx
    register-python-argcomplete --shell fish pipx | source
end

if type -q starship
    starship init fish | source
end

if type -q direnv
    direnv hook fish | source
end

if test -e "$HOME/.iterm2_shell_integration.fish"
    source $HOME/.iterm2_shell_integration.fish
end
