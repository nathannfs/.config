# Mostra o link do claude.ai/code de cada projeto ligado pelo cc-up.
# O link muda toda vez que o cc-up roda.
function cc-links --description "Links do Remote Control de cada projeto"
    if not tmux has-session -t cc 2>/dev/null
        echo "Nada ligado. Rode cc-up."
        return 1
    end
    for w in (tmux list-windows -t cc -F '#{window_name}' | string match -v acordado)
        set -l url (tmux capture-pane -p -J -t cc:$w -S -50 | string match -r 'https://claude.ai/code\?environment=\w+' | tail -1)
        echo "$w: $url"
    end
end
