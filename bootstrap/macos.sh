#!/usr/bin/env bash
# =============================================================================
# Bootstrap — macOS
# Instala dependências via Homebrew e aplica os dotfiles com stow.
# Pré-requisito: o repositório já deve estar clonado em ~/.dotfiles
# Para adicionar um novo pacote: inclua nas listas abaixo.
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

# Módulos de dotfiles a aplicar com stow (um por pasta dentro de $DOTFILES_DIR)
STOW_MODULES=(
  fastfetch
  kitty
  starship
  zsh
)

# =============================================================================
# Pacotes brew (CLI) — adicione novos pacotes aqui
# =============================================================================
BREW_PACKAGES=(
  # Controle de versão
  git

  # Editor padrão
  vim

  # Shell
  zsh
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting

  # Ferramentas CLI modernas
  fd
  fzf
  bat
  eza
  starship
  fastfetch

  # Gerenciador de dotfiles
  stow
)

# =============================================================================
# Casks (apps e fontes) — adicione novos casks aqui
# =============================================================================
BREW_CASKS=(
  # Terminal
  kitty

  # Fontes
  font-jetbrains-mono
  font-jetbrains-mono-nerd-font
)

# =============================================================================
# Helpers
# =============================================================================
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

step() { echo -e "\n${BOLD}${YELLOW}==> $1${RESET}"; }
ok()   { echo -e "${GREEN}  ✓ $1${RESET}"; }
info() { echo -e "  → $1"; }

# =============================================================================
# Instalação
# =============================================================================
step "Verificando Homebrew"
if ! command -v brew &>/dev/null; then
  info "Homebrew não encontrado — instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Garante que o brew esteja no PATH imediatamente (Apple Silicon)
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  ok "Homebrew instalado"
else
  info "Homebrew já instalado"
  brew update
fi

step "Instalando pacotes brew"
brew install "${BREW_PACKAGES[@]}"
ok "Pacotes instalados"

step "Instalando casks"
brew install --cask "${BREW_CASKS[@]}"
ok "Casks instalados"

step "Aplicando dotfiles com stow"
cd "$DOTFILES_DIR"
for module in "${STOW_MODULES[@]}"; do
  stow --restow "$module"
  info "$module aplicado"
done
ok "Todos os módulos aplicados"

step "Criando cache de cores vazio (pywal não disponível no macOS)"
mkdir -p "$HOME/.cache/wal"
# kitty usa include ~/.cache/wal/colors-kitty.conf — sem o arquivo kitty erra na inicialização
# zsh usa source ~/.cache/wal/colors.sh — já tem guard, mas cria por consistência
for f in colors-kitty.conf colors-tmux.conf colors.sh; do
  [[ -f "$HOME/.cache/wal/$f" ]] || touch "$HOME/.cache/wal/$f"
done
ok "Cache criado em ~/.cache/wal/"

step "Alterando shell padrão para zsh"
ZSH_PATH="$(brew --prefix)/bin/zsh"
SHELLS_FILE="/etc/shells"

# Registra o zsh do brew em /etc/shells se necessário
if ! grep -qF "$ZSH_PATH" "$SHELLS_FILE"; then
  echo "$ZSH_PATH" | sudo tee -a "$SHELLS_FILE" > /dev/null
  info "zsh do brew registrado em /etc/shells"
fi

if [[ "$SHELL" == "$ZSH_PATH" ]]; then
  info "Shell já é zsh"
else
  chsh -s "$ZSH_PATH"
  ok "Shell alterado para zsh (effect na próxima sessão)"
fi

echo -e "\n${BOLD}${GREEN}Setup concluído! Reinicie o terminal ou abra uma nova sessão.${RESET}\n"
