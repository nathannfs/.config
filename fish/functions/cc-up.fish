# Liga um servidor de Remote Control em cada projeto, todos numa sessao tmux "cc".
# Depois e so abrir claude.ai/code ou o app e criar/usar sessoes em qualquer pasta.
# cc-up        liga tudo (confere a memoria antes)
# cc-up -f     liga mesmo com pouca memoria livre
# cc-up -n     nao retoma a ultima conversa de cada projeto (economiza memoria)
# cc-down      desliga tudo
function cc-up --description "Liga o Remote Control nos 4 projetos"
    set -l base /Volumes/DEV/dev/nathannfs
    set -l projetos nfs-studio afiliados study finance

    if tmux has-session -t cc 2>/dev/null
        echo "Ja esta ligado. Ver: tmux attach -t cc   Desligar: cc-down"
        return 0
    end

    set -l livre (memory_pressure | tail -1 | string match -r '\d+')
    if test "$livre" -lt 25; and not contains -- -f $argv
        echo "So $livre% de memoria livre. Feche algo ou rode cc-up -f."
        return 1
    end

    for p in $projetos
        set -l dir $base/$p
        if not test -d $dir
            echo "Pasta nao encontrada, pulando: $dir"
            continue
        end
        set -l cmd "claude remote-control --spawn same-dir --no-create-session-in-dir --chrome --remote-control-session-name-prefix $p; exec fish"
        if tmux has-session -t cc 2>/dev/null
            tmux new-window -t cc -n $p -c $dir fish -c $cmd
        else
            tmux new-session -d -s cc -n $p -c $dir fish -c $cmd
        end
        # Retoma a ultima conversa do projeto (igual ao /resume), ja com Remote Control.
        # Se o projeto nao tiver conversa, o claude sai e a janela fica no fish.
        if not contains -- -n $argv
            set -l ultima "claude --continue --remote-control --chrome --remote-control-session-name-prefix $p; exec fish"
            tmux new-window -t cc -n $p-ultima -c $dir fish -c $ultima
        end
    end

    # Impede o Mac de dormir por inatividade enquanto o cc estiver ligado (morre junto no cc-down)
    tmux new-window -t cc -n acordado caffeinate -i

    echo "Ligado: $projetos"
    contains -- -n $argv; or echo "A ultima conversa de cada projeto foi retomada e aparece no app com o nome do projeto."
    echo "Links pra abrir sessao em cada projeto (aguarde uns 15 s): cc-links"
    echo "Use pelo claude.ai/code ou pelo app. Ver no terminal: tmux attach -t cc (sair sem desligar: Ctrl-b d)"
end
