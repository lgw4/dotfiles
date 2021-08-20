function fish_greeting -d "Tell me a fortune…"
    if status --is-login
        echo
        fortune
    end
end
