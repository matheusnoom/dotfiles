cleanup() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "cleanup: suporte apenas para Arch Linux (pacman)" >&2
    return 1
  fi
  (
    set -euo pipefail

    BOLD='\033[1m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    RESET='\033[0m'

    step() { echo -e "\n${BOLD}${YELLOW}==> $1${RESET}"; }
    ok()   { echo -e "${GREEN}  OK: $1${RESET}"; }
    skip() { echo -e "  --: $1 (nada encontrado)"; }

    step "Verificando dependencias orfas (pacman)"
    ORPHANS=$(pacman -Qtdq 2>/dev/null || true)

    if [[ -n "$ORPHANS" ]]; then
      echo -e "${RED}  Orfaos encontrados:${RESET}"
      echo "$ORPHANS" | sed 's/^/    - /'
      sudo pacman -Rns $ORPHANS --noconfirm
      ok "Orfaos removidos"
    else
      skip "Sem orfaos"
    fi

    step "Removendo downloads temporarios quebrados"
    local downloads=(/var/cache/pacman/pkg/download-*(N))
    if (( ${#downloads} > 0 )); then
      sudo rm -rf "${downloads[@]}"
      ok "Diretorios temporarios removidos"
    else
      skip "Nenhum download temporario encontrado"
    fi

    step "Limpando cache do pacman"
    sudo pacman -Sc --noconfirm
    ok "Cache antigo removido (versao atual mantida)"

    step "Verificando orfaos do AUR (yay)"
    if command -v yay &>/dev/null; then
      yay -Yc --noconfirm && ok "Orfaos do AUR removidos" || skip "Sem orfaos no AUR"
    else
      skip "yay nao instalado"
    fi

    step "Limpando cache do yay"
    if command -v yay &>/dev/null; then
      yay -Sc --noconfirm
      ok "Cache do yay limpo"
    else
      skip "yay nao instalado"
    fi

    step "Procurando arquivos .pacsave e .pacnew"
    PACSAVE=$(find /etc -name "*.pacsave" 2>/dev/null || true)
    PACNEW=$(find /etc  -name "*.pacnew"  2>/dev/null || true)

    if [[ -n "$PACSAVE" ]]; then
      echo -e "${RED}  .pacsave encontrados (configs antigas):${RESET}"
      echo "$PACSAVE" | sed 's/^/    /'
      echo "$PACSAVE" | xargs sudo rm -v
      ok ".pacsave removidos"
    else
      skip "Sem .pacsave"
    fi

    if [[ -n "$PACNEW" ]]; then
      echo -e "${YELLOW}  .pacnew encontrados - revisar manualmente:${RESET}"
      echo "$PACNEW" | sed 's/^/    /'
      echo -e "${YELLOW}  -> NAO removidos automaticamente. Compare e mescle.${RESET}"
    else
      skip "Sem .pacnew"
    fi

    echo -e "\n${BOLD}${GREEN}============================================================"
    echo -e "  Limpeza concluida!"
    echo -e "  Cache pacman : $(du -sh /var/cache/pacman/pkg/ 2>/dev/null | cut -f1)"
    echo -e "  Cache yay    : $(du -sh ~/.cache/yay/ 2>/dev/null | cut -f1 || echo 'N/A')"
    echo -e "============================================================${RESET}\n"
  )
}
