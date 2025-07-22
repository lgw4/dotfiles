if type -q code && not test -n "$SSH_CONNECTION"
    set -x EDITOR code
else
    set -x EDITOR vim
end
