HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY       # sincroniza histórico entre sessões (inclui INC_APPEND)
setopt HIST_REDUCE_BLANKS

# Avoid duplicated PATH entries
typeset -U path PATH

# Add custom paths safely
path=(
  $HOME/.local/bin
  $HOME/bin
  $path
)

# Completion system (deve vir antes de env.zsh para evitar que sdkman chame compinit sem -d)
autoload -Uz compinit && compinit -d "$HOME/.zcompdump"

# Variáveis de ambiente (exports puros)
source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/paths.zsh"

# Aliases, functions
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"

# Inicializadores de ferramentas externas (starship, pyenv, sdkman…)
source "$ZDOTDIR/init.zsh"

# Plugins (sempre por último — obrigatório para zsh-syntax-highlighting)
source "$ZDOTDIR/plugins.zsh"

# Startup — o que rodar ao abrir o terminal (edite manualmente)
source "$ZDOTDIR/startup.zsh"