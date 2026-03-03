# Abre o gerenciador de arquivos na pasta atual (Linux apenas)
[[ "$OSTYPE" != "darwin"* ]] && alias n='nautilus . &>/dev/null &'

alias reload='source ~/.config/zsh/.zshrc'

# eza — substituto do ls (opcional: só ativa se instalado)
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first --icons=always'
  alias lsd='eza -D --group-directories-first --icons=always'
  alias lsa='eza -A --group-directories-first --icons=always'
  alias ll='eza -lah --group-directories-first --icons=always --git'
fi

# bat — substituto do cat (opcional: só ativa se instalado)
if command -v bat >/dev/null; then
  alias cat='bat --paging=never'
fi

# fzf — fuzzy finder com preview (opcional: só ativa se fd + fzf + bat instalados)
if command -v fzf >/dev/null && command -v bat >/dev/null; then
  command -v fd >/dev/null && alias ff='fd | fzf --preview "bat --style=numbers --color=always {}"'
  alias ffa='fzf --preview "bat --style=numbers --color=always {}"'
fi

# git
alias ga='git add'
alias gp='git push'
alias gl='git pull'
alias gcb='git checkout $(git branch --all | fzf)'

# processos
alias psg='ps aux | grep -v grep | grep'

# alias clear='clear && fastfetch'