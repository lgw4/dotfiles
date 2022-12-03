###-begin-alks-completion-###
function _alks_completion
  set cmd (commandline -o)
  set cursor (commandline -C)
  set words (node -pe "'$cmd'.split(' ').length")

  set completions (eval env DEBUG=\"" \"" COMP_CWORD=\""$words\"" COMP_LINE=\""$cmd \"" COMP_POINT=\""$cursor\"" alks completion -- $cmd)

  for completion in $completions
    echo -e $completion
  end
end

complete -f -d 'alks' -c alks -a "(eval _alks_completion)"
###-end-alks-completion-###
