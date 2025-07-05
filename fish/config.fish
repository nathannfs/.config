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
