# Detecta sistema operacional para usar os caminhos corretos dos plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS — Homebrew ($HOMEBREW_PREFIX é exportado pelo brew shellenv no .zprofile)
  # fallback para /opt/homebrew (Apple Silicon); Intel usa /usr/local
  _BREW="${HOMEBREW_PREFIX:-/opt/homebrew}"
  _ZSH_AUTOSUGGESTIONS="$_BREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  _ZSH_SYNTAX="$_BREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  _FZF_KEYBINDINGS="$_BREW/opt/fzf/shell/key-bindings.zsh"
  _FZF_COMPLETION="$_BREW/opt/fzf/shell/completion.zsh"
else
  # Arch Linux
  _ZSH_AUTOSUGGESTIONS="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  _ZSH_SYNTAX="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  _FZF_KEYBINDINGS="/usr/share/fzf/key-bindings.zsh"
  _FZF_COMPLETION="/usr/share/fzf/completion.zsh"
fi

# zsh-autosuggestions: sugestões estilo Fish baseadas no histórico
[[ -f "$_ZSH_AUTOSUGGESTIONS" ]] && source "$_ZSH_AUTOSUGGESTIONS"

# zsh-syntax-highlighting
[[ -f "$_ZSH_SYNTAX" ]] && source "$_ZSH_SYNTAX"

# Estilos de cores — carregado aqui pois depende do plugin acima
source "$ZDOTDIR/colors.zsh"

# fzf: keybindings (Ctrl+R, Ctrl+T, Alt+C) e completions (ex: kill <Tab>)
[[ -f "$_FZF_KEYBINDINGS" ]] && source "$_FZF_KEYBINDINGS"
[[ -f "$_FZF_COMPLETION"  ]] && source "$_FZF_COMPLETION"

# Keybindings nativos do zsh: ↑ / ↓ buscam no histórico pelo prefixo digitado
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
