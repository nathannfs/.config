if status is-interactive
# Commands to run in interactive sessions can go here
end

set SPACEFISH_PROMPT_ADD_NEWLINE false
starship init fish | source
set -g fish_greeting ""

# Aliases
# alias cat="bat --theme=$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# pnpm
set -gx PNPM_HOME "/Users/nathannfs/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

fzf --fish | source
zoxide init fish | source

export FZF_CTRL_T_OPTS="
  --style full
  --walker-skip .git,node_modules,target
  --preview 'bat --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"
# Added by Windsurf
fish_add_path /Users/nathannfs/.codeium/windsurf/bin

# Added by Antigravity
fish_add_path /Users/nathannfs/.antigravity/antigravity/bin

# Added by Antigravity
fish_add_path /Users/nathannfs/.antigravity/antigravity/bin

# O perfil e resolvido na hora de iniciar o claude, a partir de onde voce esta.
# Nao usar --on-variable PWD: aquilo reatribuia CLAUDE_CONFIG_DIR a cada cd,
# inclusive dentro de comandos rodados pelo proprio claude.
function __claude_config_dir
    if string match -q "/Volumes/DEV/dev/omd*" -- $PWD
        echo $HOME/.claude-omd
    else
        echo $HOME/.claude-pessoal
    end
end

# Sessoes do Remote Control ganham o nome da pasta onde o claude foi aberto.
function claude --wraps claude
    CLAUDE_CONFIG_DIR=(__claude_config_dir) CLAUDE_REMOTE_CONTROL_SESSION_NAME_PREFIX=(basename $PWD) command claude $argv
end

# O macOS acha o binario com CLAUDE em maiusculas, mas o fish nao acha a funcao.
function CLAUDE --wraps claude
    claude $argv
end


# Added by Antigravity CLI installer
set -gx PATH "/Users/nathannfs/.local/bin" $PATH
