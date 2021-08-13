if test (uname) = 'Darwin'
    alias ls='ls -FG'
    alias finder='open -a Finder ./'
    if test -d '/Applications/Yoink.app'
        alias yoink='open -a Yoink'
    end
else
    alias ls='ls -F --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias gvim='gvim -f'
end
