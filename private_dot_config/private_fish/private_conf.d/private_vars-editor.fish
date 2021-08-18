if type -q code-insiders
    and not test -n "$SSH_CONNECTION"
    set -x EDITOR code-insiders
else if type -q code
    and not test -n "$SSH_CONNECTION"
    set -x EDITOR code
else
    set -x EDITOR vim
end
