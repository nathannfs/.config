# Desliga todos os servidores de Remote Control ligados pelo cc-up.
function cc-down --description "Desliga o Remote Control dos projetos"
    if not tmux has-session -t cc 2>/dev/null
        echo "Nada ligado."
        return 0
    end
    # Ctrl-C e esperar sair: se matar antes, o registro na nuvem fica preso
    # e o proximo cc-up da "already served" por uns 2 minutos.
    for w in (tmux list-windows -t cc -F '#{window_index}')
        tmux send-keys -t cc:$w C-c
    end
    for i in (seq 30)
        pgrep -f "claude remote-control" >/dev/null; or break
        sleep 1
    end
    tmux kill-session -t cc 2>/dev/null
    echo "Desligado. Se for religar, espere 1 minuto antes do cc-up."
end
