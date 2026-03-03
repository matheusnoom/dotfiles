#!/usr/bin/env bash
# =============================================================================
# Bootstrap — Arch Linux
# Instala dependências e aplica os dotfiles com stow.
# Pré-requisito: o repositório já deve estar clonado em ~/.dotfiles
# Para adicionar um novo pacote: inclua na lista PACKAGES abaixo.
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

# Módulos de dotfiles a aplicar com stow (um por pasta dentro de $DOTFILES_DIR)
STOW_MODULES=(
  fastfetch
  kitty
  starship
  tmux
  vscode
  zsh
)

# =============================================================================
# Pacotes a instalar — adicione novos pacotes aqui
# =============================================================================
PACKAGES=(
  # Controle de versão
  git

  # Editor padrão
  vim

  # Shell
  zsh
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting

  # Terminal
  kitty

  # Ferramentas CLI modernas
  fd
  fzf
  bat
  eza
  starship
  fastfetch

  # Gerenciador de dotfiles
  stow

  # Temas de cores
  python-pywal

  # Fontes
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
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
step "Atualizando índice de pacotes"
sudo pacman -Syu --noconfirm
ok "Índice atualizado"

step "Instalando pacotes"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
ok "Pacotes instalados"

step "Aplicando dotfiles com stow"
cd "$DOTFILES_DIR"
for module in "${STOW_MODULES[@]}"; do
  stow --restow "$module"
  info "$module aplicado"
done
ok "Todos os módulos aplicados"

step "Criando cache de cores vazio (pywal opcional)"
mkdir -p "$HOME/.cache/wal"
for f in colors-kitty.conf colors-tmux.conf colors.sh; do
  [[ -f "$HOME/.cache/wal/$f" ]] || touch "$HOME/.cache/wal/$f"
done
ok "Cache criado em ~/.cache/wal/"

step "Alterando shell padrão para zsh"
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
  info "Shell já é zsh"
else
  chsh -s "$ZSH_PATH"
  ok "Shell alterado para zsh (effect na próxima sessão)"
fi

step "Instalando extensões do VS Code"
EXT_FILE="$DOTFILES_DIR/vscode/extensions.txt"
if command -v code &>/dev/null && [[ -f "$EXT_FILE" ]]; then
  while IFS= read -r ext || [[ -n "$ext" ]]; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    code --install-extension "$ext" --force
    info "$ext"
  done < "$EXT_FILE"
  ok "Extensões instaladas"
else
  info "Pulando: 'code' não encontrado ou extensions.txt ausente"
fi

echo -e "\n${BOLD}${GREEN}Setup concluído! Reinicie o terminal ou abra uma nova sessão.${RESET}\n"
