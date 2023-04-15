set fish_prompt_pwd_dir_length 0

if type -q pipx
    register-python-argcomplete --shell fish pipx | source
end

if type -q vf
    set -x VIRTUALFISH_HOME "$HOME"/.local/share/virtualenvs
end

if type -q starship
    starship init fish | source
end

if type -q direnv
    direnv hook fish | source
end

# Base16 Shell
if test -d "$HOME"/.config/base16-shell
    if status --is-interactive
        set BASE16_SHELL "$HOME"/.config/base16-shell/
        source "$BASE16_SHELL"/profile_helper.fish
    end
    base16-tomorrow
end

if test -e "$HOME/".iterm2_shell_integration.fish
    source "$HOME"/.iterm2_shell_integration.fish
end
